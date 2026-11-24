/* usb_config.c - tables for the Microchip USB host stack
 *
 * Part B (saving to USB stick).
 *
 * usbTPL[]                "Targeted Peripheral List": which devices the host accepts.
 * usbClientDrvTable[]     which driver handles those devices.
 * usbMediaInterfaceTable  SCSI layer between the mass storage driver and the file system.
 */
#include <stdbool.h>
#include <stdint.h>
#include "usb_config.h"
#include "usb.h"
#include "usb_host_msd.h"
#include "usb_host_msd_scsi.h"

// Link: mass storage driver -> SCSI commands -> file system (FILEIO).
CLIENT_DRIVER_TABLE usbMediaInterfaceTable =
{
    USBHostMSDSCSIInitialize,
    USBHostMSDSCSIEventHandler,
    0
};

// Index 0: mass storage driver (Bulk-Only Transport).
CLIENT_DRIVER_TABLE usbClientDrvTable[NUM_CLIENT_DRIVER_ENTRIES] =
{
    {
        USBHostMSDInitialize,
        USBHostMSDEventHandler,
        0
    }
};

// Class 0x08 = Mass Storage, protocol 0x50 = Bulk-Only Transport.
// Subclass 0x06 (SCSI transparent) is used by almost all thumb drives,
// 0x05 (SFF-8070i) by some older models.
USB_TPL usbTPL[NUM_TPL_ENTRIES] =
{
    { INIT_CL_SC_P( 8ul, 6ul, 0x50ul ), 0, 0, {TPL_CLASS_DRV} },
    { INIT_CL_SC_P( 8ul, 5ul, 0x50ul ), 0, 0, {TPL_CLASS_DRV} }
};
