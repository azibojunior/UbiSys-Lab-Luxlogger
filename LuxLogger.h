/* LuxLogger.h - data types shared by all modules of the lux logger
 *
 * Owner: whole team. Change only after agreeing with A, B and C, because every
 * module depends on these types.
 *
 * Module overview (who owns what):
 *   A  Sensor.c/h   light sensor -> lux value            (currently a STUB)
 *   A  Clock.c/h    date and time                        (currently a STUB)
 *   A  main.c       main loop, integration
 *   B  Storage.c/h  USB stick: mount, write, read days
 *   C  UI.c/h       OLED screens, touch input, LED       (currently a STUB)
 *   -  TextDisplay.c/h, Font5x7.c/h  text output on the OLED (shared helper)
 *
 * Do NOT include PIC24FStarter.h anywhere except main.c: it contains the
 * #pragma config lines, which must appear in exactly one source file.
 */
#ifndef LUXLOGGER_H
#define LUXLOGGER_H

#include <stdint.h>
#include <stdbool.h>

// Calendar date. year is the full year (e.g. 2026), month 1..12, day 1..31.
typedef struct {
    uint16_t year;
    uint8_t  month;
    uint8_t  day;
} Date;

// Date plus time of day (24 h). second is needed for file timestamps.
typedef struct {
    Date    date;
    uint8_t hour;     // 0..23
    uint8_t minute;   // 0..59
    uint8_t second;   // 0..59
} DateTime;

// One logged measurement: one value per minute.
typedef struct {
    Date     date;
    uint8_t  hour;    // 0..23
    uint8_t  minute;  // 0..59
    uint16_t lux;     // 0..LUX_MAX
} LuxSample;

// Marker for "no measurement in this minute" (e.g. logger was off).
// Sensor code must therefore clamp real values to LUX_MAX.
#define LUX_NONE                0xFFFFu
#define LUX_MAX                 0xFFFEu

#define MINUTES_PER_DAY         1440u

#endif // LUXLOGGER_H
