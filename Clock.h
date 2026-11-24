/* Clock.h - date and time (part A)
 *
 * >>> STUB <<<  Placeholder written by part B so the project builds and the
 * USB code can stamp files. Part A replaces Clock.c completely (e.g. with the
 * RTCC module, if the board has a 32.768 kHz crystal) but should keep this
 * interface or agree on changes with B and C.
 *
 * Stub behaviour: starts at CLOCK_STUB_START (2026-01-01 00:00:00) at power-up
 * and counts real seconds using Timer4/5 as one 32-bit timer (no interrupt).
 * The time is lost on every reset. CLOCK_STUB_SPEEDUP lets the stub run faster
 * than real time, e.g. 60 = one simulated minute per second (useful in week 2
 * to produce a full day of log data in 24 minutes).
 *
 * Hardware resources used by the stub: Timer4 + Timer5.
 */
#ifndef CLOCK_H
#define CLOCK_H

#include "LuxLogger.h"

void Clock_Init(void);
void Clock_Now(DateTime *now);
void Clock_Set(const DateTime *now);

#endif // CLOCK_H
