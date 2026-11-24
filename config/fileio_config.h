/* fileio_config.h - configuration of the Microchip file system library (lib/mla_fileio)
 *
 * Part B (saving to USB stick).
 */
#ifndef FILEIO_CONFIG_H
#define FILEIO_CONFIG_H

// Exactly one drive: the USB stick.
#define FILEIO_CONFIG_MAX_DRIVES            1

// Path separator.
#define FILEIO_CONFIG_DELIMITER             '/'

// USB sticks use 512-byte sectors. FILEIO_DriveMount() rejects sticks with
// larger sectors (FILEIO_ERROR_UNSUPPORTED_SECTOR_SIZE).
#define FILEIO_CONFIG_MEDIA_SECTOR_SIZE     512

// Disabled on purpose (saves flash/RAM, fewer failure modes):
//  - Formatting: the logger must never format the user's stick.
//  - Subdirectories: the daily files live in the root directory.
//  - Drive properties (free space): "stick full" shows up as the write
//    error FILEIO_ERROR_DRIVE_FULL.
#define FILEIO_CONFIG_FORMAT_DISABLE
#define FILEIO_CONFIG_DIRECTORY_DISABLE
#define FILEIO_CONFIG_DRIVE_PROPERTIES_DISABLE

// Left enabled on purpose:
//  - Writing (FILEIO_CONFIG_WRITE_DISABLE not set).
//  - File search (FILEIO_CONFIG_SEARCH_DISABLE not set): needed in week 3
//    for Storage_ListDays().
//  - Separate buffers for FAT and data (FILEIO_CONFIG_MULTIPLE_BUFFER_MODE_DISABLE
//    not set): costs 512 bytes of RAM, saves many sector reads when appending.

#endif // FILEIO_CONFIG_H
