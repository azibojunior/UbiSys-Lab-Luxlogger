/* Storage.h - saving lux data to a USB stick (part B)
 *
 * Status (week 1): USB host + FAT file system work. The stick is detected and
 * mounted; on every mount a test line is appended to TEST.TXT (self test).
 * Storage_Append(), Storage_ListDays() and Storage_LoadDay() are declared so
 * A and C can already program against them, but they are not implemented yet
 * (week 2 and week 3). Until then they report "nothing done".
 *
 * Planned file format (week 2): one file per day in the root directory,
 * named YYYYMMDD.CSV, one fixed-width line per minute: "HH:MM,LLLLLL\r\n".
 *
 * Rules for the caller (main loop, part A):
 *  - Call Storage_Init() once after the clock is running (INIT_CLOCK()).
 *  - Call Storage_Tasks() in EVERY pass of the main loop. The USB host stack
 *    only makes progress inside this call. Long blocking delays between two
 *    calls slow down detecting and mounting the stick. (The maximum allowed
 *    gap will be measured in week 4.)
 *  - File operations (mount, append, load) block until the USB transfer is
 *    done (typically milliseconds, to be measured in week 4).
 *
 * Hardware resources used: USB module and its interrupt (priority 6),
 * heap memory for the USB stack (linker heap size must be > 0).
 */
#ifndef STORAGE_H
#define STORAGE_H

#include <stdint.h>
#include <stdbool.h>
#include "LuxLogger.h"

typedef enum {
    STORAGE_NO_STICK = 0,   // no stick attached (or not yet enumerated)
    STORAGE_READY,          // stick mounted, files can be read and written
    STORAGE_ERROR           // stick attached but unusable, see StorageInfo
} StorageState;

typedef enum {
    STORAGE_ERR_NONE = 0,
    STORAGE_ERR_UNSUPPORTED_DEVICE, // not a mass storage device (e.g. keyboard)
    STORAGE_ERR_CANNOT_ENUMERATE,   // device does not respond correctly
    STORAGE_ERR_HUB,                // USB hubs are not supported
    STORAGE_ERR_CLIENT_INIT,        // mass storage driver could not start
    STORAGE_ERR_OUT_OF_MEMORY,      // heap too small for the USB stack
    STORAGE_ERR_USB_OTHER,          // other error reported by the USB stack
    STORAGE_ERR_MOUNT,              // file system could not be mounted (see fileioError)
    STORAGE_ERR_FILE                // a file operation failed (see fileioError)
} StorageError;

// Diagnostic information, mainly for the status screen while debugging
// (the starter kit offers no usable breakpoints).
typedef struct {
    StorageState state;
    StorageError lastError;
    uint8_t      fileioError;   // FILEIO_ERROR_TYPE of the last failed file call, 0 = none
    uint8_t      fatType;       // 12, 16 or 32 when mounted, 0 = unknown
    uint16_t     mountCount;    // successful mounts since power-up
    uint16_t     selfTestOk;    // successful TEST.TXT writes since power-up
} StorageInfo;

void         Storage_Init(void);
void         Storage_Tasks(void);
StorageState Storage_GetState(void);
void         Storage_GetInfo(StorageInfo *info);

// --- Planned API, not implemented yet ------------------------------------
// Week 2: append one sample to the file of s->date. Returns false if the
// sample was NOT written to the stick (no stick, error, or not implemented).
bool         Storage_Append(const LuxSample *s);

// Week 3: fill days[] with the dates that have a file on the stick, sorted
// ascending. Returns the number of dates written (0..max).
uint8_t      Storage_ListDays(Date *days, uint8_t max);

// Week 3: read the file of day d into lux[0..MINUTES_PER_DAY-1], index =
// hour * 60 + minute. Minutes without a value are set to LUX_NONE.
// Returns false if the day could not be read.
bool         Storage_LoadDay(Date d, uint16_t lux[MINUTES_PER_DAY]);

#endif // STORAGE_H
