/* Storage.c - saving lux data to a USB stick (part B)
 *
 * Layers (bottom to top):
 *   USB module + interrupt  ->  lib/mla_usb  usb_host.c         (enumeration, transfers)
 *                            ->  lib/mla_usb  usb_host_msd*.c    (mass storage, SCSI)
 *                            ->  lib/mla_fileio fileio.c         (FAT12/16/32)
 *                            ->  this file                       (logger logic)
 *
 * State machine in Storage_Tasks():
 *   NO_STICK --(stick enumerated + media ready)--> mount --ok--> READY
 *                                                       \--fail--> ERROR
 *   READY / ERROR --(stick removed)--> NO_STICK
 * A failed mount is not retried while the same stick stays plugged in, so a
 * broken stick does not trigger endless mount attempts.
 */
#include <xc.h>
#include <stddef.h>
#include "Storage.h"
#include "Clock.h"
#include "usb_config.h"
#include "usb.h"
#include "usb_host_msd.h"
#include "usb_host_msd_scsi.h"
#include "fileio.h"

// Week 1 self test: append one line to TEST.TXT after every successful mount.
// Set to 0 as soon as Storage_Append() works (week 2): the finished logger
// should not leave test files on the user's stick.
#define STORAGE_SELFTEST_ON_MOUNT   1

#define STORAGE_DRIVE_ID            'A'
#define SELFTEST_FILE_NAME          "TEST.TXT"

// Function table that connects FILEIO to the USB mass storage driver.
// The casts are needed because the SCSI functions take "uint8_t *address"
// and return uint8_t, while FILEIO expects "void *" and bool. Both use the
// same registers on the PIC24, and the SCSI functions only return 0/1 here
// (this is also how the Microchip demos connect the two libraries).
static const FILEIO_DRIVE_CONFIG usbDrive =
{
    (FILEIO_DRIVER_IOInitialize)NULL,
    (FILEIO_DRIVER_MediaDetect)USBHostMSDSCSIMediaDetect,
    (FILEIO_DRIVER_MediaInitialize)USBHostMSDSCSIMediaInitialize,
    (FILEIO_DRIVER_MediaDeinitialize)USBHostMSDSCSIMediaDeinitialize,
    (FILEIO_DRIVER_SectorRead)USBHostMSDSCSISectorRead,
    (FILEIO_DRIVER_SectorWrite)USBHostMSDSCSISectorWrite,
    (FILEIO_DRIVER_WriteProtectStateGet)USBHostMSDSCSIWriteProtectState
};

// USB address of the attached stick, 0 = none. Set and cleared by the USB
// event handler; its address is passed to FILEIO as "media parameters".
static volatile uint8_t usbDeviceAddress = 0;

static StorageState state = STORAGE_NO_STICK;
static bool         mounted = false;
static StorageInfo  info;

// ---------------------------------------------------------------------------
// Small helpers (no printf: keeps the code independent of the C library,
// which differs between XC16 and XC-DSC)
// ---------------------------------------------------------------------------

// Writes value with exactly "digits" digits (leading zeros) to dst.
// Returns a pointer behind the last written character.
static char *PutUInt(char *dst, uint16_t value, uint8_t digits)
{
    for (int8_t i = (int8_t)digits - 1; i >= 0; i--) {
        dst[i] = (char)('0' + (value % 10u));
        value /= 10u;
    }
    return dst + digits;
}

static char *PutText(char *dst, const char *text)
{
    while (*text) {
        *dst++ = *text++;
    }
    return dst;
}

static void SetError(StorageError error, uint8_t fileioError)
{
    info.lastError   = error;
    info.fileioError = fileioError;
}

// True while the enumerated stick answers as a working mass storage device.
static bool StickPresent(void)
{
    uint8_t address = usbDeviceAddress;
    return (address != 0) && USBHostMSDSCSIMediaDetect(&address);
}

// FILEIO asks for the current time when it creates or changes a file.
static void Storage_TimestampGet(FILEIO_TIMESTAMP *timestamp)
{
    DateTime now;
    Clock_Now(&now);

    uint16_t year = now.date.year;
    if (year < 1980u) year = 1980u;     // FAT dates start in 1980
    if (year > 2107u) year = 2107u;     // and end in 2107

    timestamp->date.bitfield.year        = year - 1980u;
    timestamp->date.bitfield.month       = now.date.month;
    timestamp->date.bitfield.day         = now.date.day;
    timestamp->time.bitfield.hours       = now.hour;
    timestamp->time.bitfield.minutes     = now.minute;
    timestamp->time.bitfield.secondsDiv2 = now.second / 2u;
    timestamp->timeMs                    = (uint8_t)((now.second % 2u) * 100u); // 10 ms units
}

// ---------------------------------------------------------------------------
// Week 1 self test
// ---------------------------------------------------------------------------
#if STORAGE_SELFTEST_ON_MOUNT
// Appends e.g. "LuxLogger self test #3, FAT32, 2026-01-01 00:00:42\r\n" to TEST.TXT.
static bool WriteSelfTestLine(void)
{
    char line[64];
    char *p = line;
    DateTime now;
    Clock_Now(&now);

    p = PutText(p, "LuxLogger self test #");
    p = PutUInt(p, info.mountCount, 5);
    p = PutText(p, ", FAT");
    p = PutUInt(p, info.fatType, 2);
    p = PutText(p, ", ");
    p = PutUInt(p, now.date.year, 4);  *p++ = '-';
    p = PutUInt(p, now.date.month, 2); *p++ = '-';
    p = PutUInt(p, now.date.day, 2);   *p++ = ' ';
    p = PutUInt(p, now.hour, 2);       *p++ = ':';
    p = PutUInt(p, now.minute, 2);     *p++ = ':';
    p = PutUInt(p, now.second, 2);
    p = PutText(p, "\r\n");
    size_t length = (size_t)(p - line);

    FILEIO_OBJECT file;
    if (FILEIO_Open(&file, SELFTEST_FILE_NAME,
                    FILEIO_OPEN_WRITE | FILEIO_OPEN_CREATE | FILEIO_OPEN_APPEND)
            != FILEIO_RESULT_SUCCESS) {
        SetError(STORAGE_ERR_FILE, (uint8_t)FILEIO_ErrorGet(STORAGE_DRIVE_ID));
        return false;
    }

    size_t written = FILEIO_Write(line, 1, length, &file);
    // Always close: only a closed file has its size stored in the directory.
    int closeResult = FILEIO_Close(&file);

    if ((written != length) || (closeResult != FILEIO_RESULT_SUCCESS)) {
        SetError(STORAGE_ERR_FILE, (uint8_t)FILEIO_ErrorGet(STORAGE_DRIVE_ID));
        return false;
    }
    return true;
}
#endif

// ---------------------------------------------------------------------------
// Mounting
// ---------------------------------------------------------------------------
static void TryMount(void)
{
    FILEIO_ERROR_TYPE result = FILEIO_DriveMount(STORAGE_DRIVE_ID, &usbDrive,
                                                 (void *)&usbDeviceAddress);
    if (result != FILEIO_ERROR_NONE) {
        SetError(STORAGE_ERR_MOUNT, (uint8_t)result);
        state = STORAGE_ERROR;
        return;
    }

    mounted = true;
    info.mountCount++;
    SetError(STORAGE_ERR_NONE, 0);

    switch (FILEIO_FileSystemTypeGet(STORAGE_DRIVE_ID)) {
        case FILEIO_FILE_SYSTEM_TYPE_FAT12: info.fatType = 12; break;
        case FILEIO_FILE_SYSTEM_TYPE_FAT16: info.fatType = 16; break;
        case FILEIO_FILE_SYSTEM_TYPE_FAT32: info.fatType = 32; break;
        default:                            info.fatType = 0;  break;
    }
    state = STORAGE_READY;

#if STORAGE_SELFTEST_ON_MOUNT
    if (WriteSelfTestLine()) {
        info.selfTestOk++;
    } else {
        state = STORAGE_ERROR;      // e.g. write-protected or full stick
    }
#endif
}

static void Unmount(void)
{
    if (mounted) {
        // Nothing is cached at this point (every file is closed right after
        // use), so this only releases the drive slot inside FILEIO.
        FILEIO_DriveUnmount(STORAGE_DRIVE_ID);
        mounted = false;
    }
    info.fatType = 0;
}

// ---------------------------------------------------------------------------
// Public API
// ---------------------------------------------------------------------------
void Storage_Init(void)
{
    info.state       = STORAGE_NO_STICK;
    info.lastError   = STORAGE_ERR_NONE;
    info.fileioError = 0;
    info.fatType     = 0;
    info.mountCount  = 0;
    info.selfTestOk  = 0;
    state   = STORAGE_NO_STICK;
    mounted = false;
    usbDeviceAddress = 0;

    FILEIO_Initialize();
    FILEIO_RegisterTimestampGet(Storage_TimestampGet);
    USBHostInit(0);             // switches on VBUS and waits for a device
}

void Storage_Tasks(void)
{
    USBTasks();

    switch (state) {
        case STORAGE_NO_STICK:
            if (StickPresent()) {
                TryMount();
            }
            break;

        case STORAGE_READY:
        case STORAGE_ERROR:
            if (!StickPresent()) {
                Unmount();
                state = STORAGE_NO_STICK;
                // lastError is kept so the UI can still show why it failed.
            }
            break;
    }
    info.state = state;
}

StorageState Storage_GetState(void)
{
    return state;
}

void Storage_GetInfo(StorageInfo *out)
{
    if (out != NULL) {
        *out = info;
        out->state = state;
    }
}

// --- Planned API, not implemented yet (see Storage.h) ----------------------
bool Storage_Append(const LuxSample *s)
{
    (void)s;
    return false;   // TODO week 2: write "HH:MM,LLLLLL\r\n" to YYYYMMDD.CSV
}

uint8_t Storage_ListDays(Date *days, uint8_t max)
{
    (void)days;
    (void)max;
    return 0;       // TODO week 3: search *.CSV in the root directory
}

bool Storage_LoadDay(Date d, uint16_t lux[MINUTES_PER_DAY])
{
    (void)d;
    for (uint16_t i = 0; i < MINUTES_PER_DAY; i++) {
        lux[i] = LUX_NONE;
    }
    return false;   // TODO week 3: parse YYYYMMDD.CSV
}

// ---------------------------------------------------------------------------
// USB stack callbacks
// ---------------------------------------------------------------------------

// The host stack only provides USB_HostInterruptHandler(); the interrupt
// vector itself has to be defined by the application.
void __attribute__((interrupt, auto_psv)) _USB1Interrupt(void)
{
    USB_HostInterruptHandler();
}

// Called by the host stack for application-level events (see usb_config.h).
// The return value matters: e.g. "false" for EVENT_VBUS_REQUEST_POWER would
// reject the stick, "true" for EVENT_HOLD_BEFORE_CONFIGURATION would stop
// the enumeration. Unknown events therefore return false (= stack default).
bool USB_ApplicationEventHandler(uint8_t address, USB_EVENT event, void *data, uint32_t size)
{
    (void)data;
    (void)size;

    switch ((int)event) {
        case EVENT_VBUS_REQUEST_POWER:
            // The board supplies VBUS directly and cannot limit the current,
            // so every request is accepted.
            return true;

        case EVENT_VBUS_RELEASE_POWER:
            // Sent when the attached device is removed.
            usbDeviceAddress = 0;
            return true;

        case EVENT_MSD_ATTACH:
            // A mass storage device finished enumeration; data = LUN index.
            usbDeviceAddress = address;
            return true;

        case EVENT_HUB_ATTACH:
            SetError(STORAGE_ERR_HUB, 0);
            return true;

        case EVENT_UNSUPPORTED_DEVICE:
            SetError(STORAGE_ERR_UNSUPPORTED_DEVICE, 0);
            return true;

        case EVENT_CANNOT_ENUMERATE:
            SetError(STORAGE_ERR_CANNOT_ENUMERATE, 0);
            return true;

        case EVENT_CLIENT_INIT_ERROR:
            SetError(STORAGE_ERR_CLIENT_INIT, 0);
            return true;

        case EVENT_OUT_OF_MEMORY:
            SetError(STORAGE_ERR_OUT_OF_MEMORY, 0);
            return true;

        case EVENT_UNSPECIFIED_ERROR:
            SetError(STORAGE_ERR_USB_OTHER, 0);
            return true;

        default:
            break;
    }
    return false;
}
