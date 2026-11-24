/* Clock.c - date and time (part A)
 *
 * >>> STUB <<<  See Clock.h. Replace this file with the real implementation.
 */
#include <xc.h>
#include "Clock.h"

#define CLOCK_STUB_SPEEDUP      1u          // 1 = real time, 60 = 1 min per second
#define TIMER_TICKS_PER_SECOND  62500ul     // FCY 16 MHz / prescaler 256
#define SECONDS_PER_DAY         86400ul

static const DateTime CLOCK_STUB_START = { { 2026, 1, 1 }, 0, 0, 0 };

static Date     currentDate;    // date of the current day
static uint32_t secondOfDay;    // seconds since midnight of currentDate (may exceed
                                // one day until the next Normalize())
static uint32_t pendingTicks;   // timer ticks not yet counted as a full second
static uint32_t lastRaw;        // timer value at the previous update

static uint32_t ReadTimer45(void)
{
    // In 32-bit mode, reading TMR4 (low word) latches the high word into TMR5HLD.
    uint16_t low  = TMR4;
    uint16_t high = TMR5HLD;
    return ((uint32_t)high << 16) | low;
}

static bool IsLeapYear(uint16_t year)
{
    return ((year % 4u) == 0u && (year % 100u) != 0u) || ((year % 400u) == 0u);
}

static uint8_t DaysInMonth(uint16_t year, uint8_t month)
{
    static const uint8_t days[12] = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 };
    if (month == 2u && IsLeapYear(year)) return 29;
    return days[month - 1u];
}

static void NextDay(Date *date)
{
    if (++date->day > DaysInMonth(date->year, date->month)) {
        date->day = 1;
        if (++date->month > 12u) {
            date->month = 1;
            date->year++;
        }
    }
}

// Adds the timer ticks since the last call and rolls over to the next day(s).
// The subtraction "raw - lastRaw" also works across the 32-bit wrap-around
// (after about 19 hours), as long as this runs at least once per 19 hours.
static void Update(void)
{
    uint32_t raw = ReadTimer45();
    pendingTicks += raw - lastRaw;
    lastRaw = raw;

    uint32_t seconds = pendingTicks / TIMER_TICKS_PER_SECOND;
    pendingTicks -= seconds * TIMER_TICKS_PER_SECOND;
    secondOfDay += seconds * CLOCK_STUB_SPEEDUP;

    while (secondOfDay >= SECONDS_PER_DAY) {
        secondOfDay -= SECONDS_PER_DAY;
        NextDay(&currentDate);
    }
}

void Clock_Init(void)
{
    T4CON = 0;
    T5CON = 0;
    T4CONbits.T32   = 1;        // Timer4 + Timer5 = one 32-bit timer
    T4CONbits.TCKPS = 0b11;     // prescaler 1:256
    TMR5 = 0;
    TMR4 = 0;
    PR5  = 0xFFFF;
    PR4  = 0xFFFF;
    IEC1bits.T5IE = 0;          // no interrupt needed, we only read the counter
    T4CONbits.TON = 1;

    lastRaw = 0;
    pendingTicks = 0;
    Clock_Set(&CLOCK_STUB_START);
}

void Clock_Set(const DateTime *now)
{
    Update();                   // consume ticks that belong to the old time
    currentDate = now->date;
    secondOfDay = (uint32_t)now->hour * 3600ul + (uint32_t)now->minute * 60ul + now->second;
}

void Clock_Now(DateTime *now)
{
    Update();
    now->date   = currentDate;
    now->hour   = (uint8_t)(secondOfDay / 3600ul);
    now->minute = (uint8_t)((secondOfDay / 60ul) % 60ul);
    now->second = (uint8_t)(secondOfDay % 60ul);
}
