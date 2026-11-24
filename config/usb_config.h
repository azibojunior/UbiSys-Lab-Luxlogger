/* usb_config.h - configuration of the Microchip USB host stack (lib/mla_usb)
 *
 * Part B (saving to USB stick).
 *
 * The board acts as an "embedded host" and supports exactly one device class:
 * USB mass storage (thumb drives) using SCSI commands over Bulk-Only Transport.
 * Everything not set here uses the stack defaults
 * (see lib/mla_usb/inc/usb_host.h and lib/mla_usb/src/usb_host_local.h).
 */
#ifndef USB_CONFIG_H
#define USB_CONFIG_H

// The board is a host only (no USB device mode, no OTG role switching).
#define USB_SUPPORT_HOST

// Ping-pong buffers on all endpoints: the default in all Microchip host demos.
#define USB_PING_PONG_MODE              USB_PING_PONG__FULL_PING_PONG

// Thumb drives only use control and bulk transfers. Interrupt and isochronous
// transfers stay disabled on purpose (less code, less RAM).
#define USB_SUPPORT_BULK_TRANSFERS

// Number of entries in usbTPL[] and usbClientDrvTable[] (see usb_config.c).
#define NUM_TPL_ENTRIES                 2
#define NUM_CLIENT_DRIVER_ENTRIES       1

// Current the host requests when switching on VBUS, in units of 2 mA.
// The stack requires 100 mA for a pure host.
#define USB_INITIAL_VBUS_CURRENT        (100/2)

// Host stack events are delivered to this function (implemented in Storage.c).
#define USB_HOST_APP_EVENT_HANDLER      USB_ApplicationEventHandler

// Report transfer events through a queue (as the Microchip demos do).
#define USB_ENABLE_TRANSFER_EVENT

// Only one thumb drive at a time.
#define USB_MAX_MASS_STORAGE_DEVICES    1

// One call runs one step of the host stack and of the mass storage driver.
// The file system functions (FILEIO_*) call this themselves while they wait
// for a transfer to finish.
#define USBTasks()                      { USBHostTasks(); USBHostMSDTasks(); }

#endif // USB_CONFIG_H
