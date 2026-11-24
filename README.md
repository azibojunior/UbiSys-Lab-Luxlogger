# UbiSys-Lab-Luxlogger

The lux logger records a light sensor once per minute, saves the values to a USB stick and shows the data of a selected day on the OLED of the PIC24F Starter Kit 1.

Tasks:

- Logging of light sensor: Mehmet (part A)
- Save to USB stick: Lopez (part B)
- Display data by selecting days: azibo (part C)

## Base project

Based on [pic24fStarter](https://github.com/kristofvl/pic24fStarter) by Kristof Van Laerhoven: a minimal project for the PIC24F Starter Kit 1 board, open the project with the [MPLab X IDE](https://www.microchip.com/en-us/tools-resources/develop/mplab-x-ide) to start.

## Modules and owners

| File | Owner | Status |
|---|---|---|
| `LuxLogger.h` | team | shared data types (`Date`, `DateTime`, `LuxSample`) |
| `main.c` | A | main loop, currently only runs the modules |
| `Sensor.c/h` | A | **stub**: potentiometer instead of a light sensor |
| `Clock.c/h` | A | **stub**: starts at 2026-01-01 00:00:00 on every reset (Timer4/5) |
| `Storage.c/h` | B | USB stick detection and mounting work, test write to `TEST.TXT`; append/list/load follow in weeks 2 and 3 |
| `UI.c/h` | C | **stub**: status screen and status LED |
| `TextDisplay.c/h`, `Font5x7.c/h` | shared | text output on the OLED (8 rows, 21 characters) |
| `config/` | B | configuration of the USB and file system libraries |
| `lib/` | Microchip | third-party libraries, unchanged (see below) |
| `tools/flash.ps1` | B | program and verify the board from the command line |

Stubs are placeholders with the final interface. Replace the `.c` file, keep the `.h` interface (or agree on changes with the others).

Only `main.c` may include `PIC24FStarter.h`: it contains the `#pragma config` lines, which must appear in exactly one source file.

## Building

- MPLAB X IDE v6.35, compiler **XC-DSC v3.31.01**, device pack PIC24F-GA-GB_DFP 1.11.479.
  XC-DSC is the successor of XC16 and also supports the PIC24F. The original pic24fStarter used XC16 v2.10. **Team decision needed:** everybody should use the same compiler, otherwise MPLAB X rewrites `nbproject/configurations.xml` on every switch.
- Linker heap: 2048 bytes (Project Properties -> linker options, `xc-dsc-ld` or `xc16-ld` -> Heap size). The USB host stack allocates memory with `malloc()`. Without a heap the stick is never detected.
- Include directories: `config`, `lib/mla_usb/inc`, `lib/mla_fileio/inc`.
- The generated makefiles contain the name of the project folder. Clone the repository into a folder with the same name on every computer (e.g. `LuxLogger`), otherwise the makefiles change on every build.

## Flashing

MPLAB X once reported "Programming completed" although the chip still contained the old program. `tools/flash.ps1` (Windows) programs the board with the MPLAB command-line debugger and then reads the flash back to compare every byte:

```
powershell -ExecutionPolicy Bypass -File tools\flash.ps1
```

The starter kit offers no usable breakpoints (0 program breakpoints in MPLAB X), so debug output goes to the OLED (`Text_PrintLine()`) and the RGB LED.

## Testing the USB part (week 1)

1. Format a USB stick as **FAT32** (FAT16 also works). exFAT is not supported, so sticks larger than 32 GB usually need to be reformatted.
2. Flash the board and plug the stick into the USB-A port on the application side of the board.
3. Expected: `USB: READY FAT32`, the LED turns green and `Test` counts up by one per insertion. `TEST.TXT` on the stick gets one line per insertion.
4. Remove the stick: `USB: NO STICK`, the LED turns off.
5. Error codes in row 3 (`ERR ... nn`) are values of `FILEIO_ERROR_TYPE` (see `lib/mla_fileio/inc/fileio.h`).
6. If the stick does not even get power (its LED stays off): the USB stack switches VBUS on through the USB module's VBUSON output (RB5 on this chip). `CTMUInit()` writes the whole `TRISB` register, so check in the board schematic how VBUS is switched on the starter kit before changing anything.

## Hardware resources

| Resource | Used by |
|---|---|
| Timer1 | `delay()` in `main.c` (blocking) |
| Timer2, OC1-OC3 | RGB LED PWM (`RGBLeds.c`) |
| Timer4 + Timer5 | clock stub (`Clock.c`), free again once A replaces it |
| ADC, CTMU | touch pads and potentiometer (`TouchSense.c`) |
| PMP | OLED (`SH1101A.c`) |
| USB module, USB interrupt (priority 6) | `Storage.c` / `lib/mla_usb` |
| Heap (2048 bytes) | USB host stack |

## Third-party code

| Folder | Source | Licence |
|---|---|---|
| `lib/mla_usb` | [MicrochipTech/mla_usb](https://github.com/MicrochipTech/mla_usb), commit `d28cc13` (MLA v2018_11_26), only the host and mass storage files | Apache 2.0 |
| `lib/mla_fileio` | [MicrochipTech/mla_fileio](https://github.com/MicrochipTech/mla_fileio), commit `6c88d3e`, 8.3 file names only | Apache 2.0 |
| `Font5x7.c/h` | [mkdmc/pic24-secret-key](https://github.com/mkdmc/pic24-secret-key), commit `4c1e3df` | GPL-3.0 |

The library files are unchanged. Known issue in `usb_host.c` (compiler warning "bitwise comparison always evaluates to false" in `_USB_FindNextToken`): the check for a suspended bus can never be true. This does not affect the logger, because it never suspends the bus.
