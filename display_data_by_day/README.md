# Display data by selecting days

Part of the **UbiSys Lab Lux Logger** (PIC24F Starter Kit 1). The logger records the light level once per minute (*Logging of light sensor*, Mehmet) and saves it to a USB stick (*Save to USB stick*, Lopez). This part shows the stored data on the OLED: the user **selects a day with the touch pads and sees it as a bar graph**.

Owner: Azibo Junior Balgah · Branch: `display_data_by_day` · Folder: `display_data_by_day/`

**This folder is a complete MPLAB X project of its own.** It builds and runs on the board without the other parts and without any other branch, so this work stays safe and can be shown on its own even if combining the parts causes problems. It uses exactly the team's function and type names, so the user interface can later be copied into the team project unchanged.

Status: description and plan; the code follows step by step (see `docs/PLAN.md`).

## Features

| Feature | Description | Status |
|---|---|---|
| **Own MPLAB project** | This folder builds and runs on the starter kit by itself, without the other parts or branches | planned |
| **Stand-ins with the team's interfaces** | Clock, sensor and USB stick are replaced by stand-ins that have exactly the team's function names | planned |
| **Live screen** | Current light value (lux), date, time and USB stick state, refreshed once per second | planned |
| **Touch counting** | A pad counts only after it was touched for 3 passes in a row; holding it counts once, a short glitch not at all | planned |
| **Redraw only when needed** | The screen is drawn again only when something changes (the live screen once per second) | planned |
| **Day list** | All days on the USB stick, newest first, 5 per page, `>` cursor and position counter (`2/3`) | planned |
| **Day graph** | 24 bars = average lux of each hour of the selected day; header with date and maximum; hour labels 0/6/12/18 | planned |
| **Browse days in the graph** | Left/right jumps to the older/newer day without going back to the list | planned |
| **Missing data** | Hours without measurements are drawn as a dot, not as a zero bar | planned |
| **Display timeout** | The screen goes dark after 30 s without touch; the first touch only wakes it up | planned |
| **Status LED** | Green = stick ready, red = stick error, off = no stick or display asleep | planned |
| **Set date and time** | Year, month, day, hour, minute with the pads; day limited to the month length, leap years | planned |
| **Loading message** | "Loading day ..." while a day is read from the stick | planned |
| **Runs in the team project** | UI.c, DayData and UIDraw copied into the team project, days read from the real USB stick (see `docs/INTEGRATION.md`) | planned |

## How this folder works on its own

| Kind | Files | Where they come from |
|---|---|---|
| My code | `UI.c`, `DayData.c/.h`, `UIDraw.c/.h`, `main.c` | written for this part |
| Board drivers | `SH1101A.c/.h` (OLED), `TouchSense.c/.h` (pads), `RGBLeds.c/.h` (LED), `PIC24FStarter.h`, `LICENSE` | copied unchanged from the professor's [pic24fStarter](https://github.com/kristofvl/pic24fStarter) |
| Text output | `TextDisplay.c/.h`, `Font5x7.c/.h` | copied unchanged from the team project (font from [mkdmc/pic24-secret-key](https://github.com/mkdmc/pic24-secret-key), GPL-3.0) |
| Interfaces | `LuxLogger.h`, `Clock.h`, `Sensor.h`, `Storage.h`, `UI.h` | same declarations as in the team project |
| Stand-ins | `StubClock.c`, `StubSensor.c`, `StubStorage.c` | take the place of the other parts while this folder runs alone; `StubClock.c` is a copy of the team's clock stub |
| Project | `Makefile`, `nbproject/` | MPLAB X project of this folder: PIC24FJ256GB106, PIC24F Starter Kit 1, XC-DSC compiler |

The stand-ins behave like this: the clock starts at 2026-01-01 00:00 after every reset, the potentiometer acts as the light sensor, and the "USB stick" always holds three invented days (24 to 26 Nov 2026; on the 25th the logger was "off" until 08:00).

## Button mapping

```text
          UP
   LEFT  CENTER  RIGHT
         DOWN
```

| Screen | UP / DOWN | LEFT | RIGHT | CENTER |
|---|---|---|---|---|
| LIVE | – | – | set time | day list |
| DAY LIST | move cursor | back to LIVE | – | open graph |
| GRAPH | – | older day | newer day | back to list |
| SET TIME | value + / − | previous field | next field | save, back to LIVE |

## State machine

```text
                  ┌──────────────────────┐
     power on ──► │        LIVE          │ ◄──────────────┐
                  │ lux · date · time    │                │
                  │ USB state            │                │ CENTER (save)
                  └──┬────────────────┬──┘                │
            CENTER   │                │  RIGHT       ┌────┴─────────┐
                     ▼                └────────────► │   SET TIME   │
                  ┌──────────────────────┐           └──────────────┘
                  │       DAY LIST       │
                  │ UP/DOWN select a day │── LEFT ──► LIVE
                  └──┬───────────────────┘
            CENTER   │      ▲ CENTER
                     ▼      │
                  ┌──────────────────────┐
                  │        GRAPH         │  LEFT/RIGHT: older/newer day
                  │ 24 hourly bars       │
                  └──────────────────────┘

  any screen ── 30 s no touch ──► DISPLAY OFF ── first touch ──► same screen again
```

## How a day becomes a graph

```text
USB stick file 20261126.CSV  ("HH:MM,LLLLLL" per minute)
      │  Storage_LoadDay(date, minutes)      (USB code; here: StubStorage.c)
      ▼
minutes[1440]   one value per minute, LUX_NONE = no measurement
      │  DayData_Hourly()   average of each 60 minutes, LUX_NONE skipped
      ▼
hourly[24]      LUX_NONE if a whole hour has no measurement
      │  DayData_BarHeight()  linear: largest hour of the day = 46 px
      ▼
UIDraw_Bar()    draws each bar pixel by pixel with PutPixel() → 24 bars of 4 px
```

The OLED has 128 × 64 pixels, so 1440 minute values cannot be shown one by one; 24 bars of 4 px with 1 px gaps fill 120 px and stay readable.

## Design decisions

* **Independent, but compatible.** Own project and stand-ins, but the team's names (`Storage_ListDays()`, `Clock_Now()`, `Date`, `LUX_NONE` …), so nothing in `UI.c` changes when it moves into the team project.
* **Non-blocking.** `UI_Update()` returns after a few milliseconds and never waits for a touch, because in the team project the USB code (`Storage_Tasks()`) must run in every pass of the main loop.
* **Simple drawing.** Bars are drawn pixel by pixel with the professor's `PutPixel()`. A full graph has at most 24 × 4 × 46 = 4416 pixels, which is fast enough.
* **Redraw only when needed.** Drawing one text line takes several milliseconds, so the screen is drawn again only after a touch or, on the live screen, once per second.
* **Touch counting.** A counter per pad counts the passes in a row in which the pad is touched; the pad counts as pressed when the counter reaches 3.
* **Idle time from the clock.** The 30 s timeout uses `Clock_Now()`, so it does not depend on the length of a loop pass.

## Interfaces used by the user interface

| From | Function | Used for |
|---|---|---|
| Logging of light sensor | `Clock_Now()`, `Clock_Set()`, `Sensor_ReadLux()` | time, date, setting the clock, live lux |
| Save to USB stick | `Storage_GetState()`, `Storage_ListDays(Date*, max)`, `Storage_LoadDay(Date, uint16_t[1440])` | stick state, list of days (ascending), one day of minute values |
| main.c | calls `UI_Init()` once and `UI_Update()` in every loop pass | – |
| board drivers | `Text_PrintLine()`, `SetRGBs()`, `buttons[]` | text, LED, touch pads |

## Building and running

1. MPLAB X: *File → Open Project* → select the folder `display_data_by_day` → *Open Project*.
2. *Production → Clean and Build Main Project*, then *Production → Make and Program Device Main Project* with the starter kit connected.

No other folder or branch is needed. Moving the user interface into the team project: `docs/INTEGRATION.md`.

## Testing

* **PC (optional, needs gcc):** `sh display_data_by_day/test/run_daydata_test.sh` tests the hour averaging.
* **Board:** each step tested on the board before its commit; notes in `docs/NOTES.md`.

## Hardware and memory

OLED (PMP), 5 capacitive pads (CTMU/ADC via `ReadCTMU()`), RGB LED (Timer2, OC1–OC3), Timer1 for `delay()`; the clock stand-in uses Timer4/5. The user interface itself uses **no timer and no interrupt**. RAM of the user interface: about 2.9 KB for one loaded day (`minutes[1440]`) plus about 0.4 KB of other state (the chip has 16 KB).

## Credits

* Board drivers and `delay()`: [pic24fStarter](https://github.com/kristofvl/pic24fStarter), kvl@eti.uni-siegen.de
* `TextDisplay` and the clock stub: team project (branch `saving_to_USB`, Lopez); font from [mkdmc/pic24-secret-key](https://github.com/mkdmc/pic24-secret-key)
* Ideas from earlier lab projects: `docs/REFERENCES.md`
