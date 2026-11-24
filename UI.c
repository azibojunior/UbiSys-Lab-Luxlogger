/* UI.c - screens, touch input and status LED (part C)
 *
 * >>> STUB <<<  See UI.h. Replace this file with the real user interface.
 *
 * Screen layout of the stub (text rows 0..7):
 *   0  LUX LOGGER   UI STUB
 *   2  USB: <state>
 *   3  <last error, if any>
 *   4  Mounts <n>  Test <n>
 *   6  Lux <value> (pot)
 *   7  <date> <time>
 */
#include <stddef.h>
#include "UI.h"
#include "TextDisplay.h"
#include "SH1101A.h"
#include "RGBLeds.h"
#include "Storage.h"
#include "Sensor.h"
#include "Clock.h"

#define LED_LEVEL   40      // 0..255, kept low so the LED does not dazzle
#define LINE_BUFFER 32      // longer than a row (21): Text_PrintLine() cuts off

static StorageInfo shownInfo;
static uint8_t     shownSecond = 0xFF;
static bool        infoValid = false;

// --- small text helpers (no printf, see Storage.c) ---------------------------
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
    while (*text) *dst++ = *text++;
    return dst;
}

static const char *ErrorText(StorageError error)
{
    switch (error) {
        case STORAGE_ERR_NONE:               return "";
        case STORAGE_ERR_UNSUPPORTED_DEVICE: return "ERR NOT A STICK";
        case STORAGE_ERR_CANNOT_ENUMERATE:   return "ERR ENUMERATION";
        case STORAGE_ERR_HUB:                return "ERR HUB UNSUPPORTED";
        case STORAGE_ERR_CLIENT_INIT:        return "ERR MSD DRIVER";
        case STORAGE_ERR_OUT_OF_MEMORY:      return "ERR OUT OF HEAP";
        case STORAGE_ERR_USB_OTHER:          return "ERR USB";
        case STORAGE_ERR_MOUNT:              return "ERR MOUNT FILEIO";
        case STORAGE_ERR_FILE:               return "ERR FILE FILEIO";
    }
    return "ERR ?";
}

static void DrawStorage(const StorageInfo *s)
{
    char line[LINE_BUFFER];
    char *p;

    p = PutText(line, "USB: ");
    switch (s->state) {
        case STORAGE_NO_STICK: p = PutText(p, "NO STICK"); break;
        case STORAGE_READY:    p = PutText(p, "READY FAT"); p = PutUInt(p, s->fatType, 2); break;
        case STORAGE_ERROR:    p = PutText(p, "ERROR"); break;
    }
    *p = '\0';
    Text_PrintLine(2, line);

    p = PutText(line, ErrorText(s->lastError));
    if (s->fileioError != 0) {
        *p++ = ' ';
        p = PutUInt(p, s->fileioError, 2);
    }
    *p = '\0';
    Text_PrintLine(3, line);

    p = PutText(line, "Mounts ");
    p = PutUInt(p, s->mountCount, 3);
    p = PutText(p, "  Test ");
    p = PutUInt(p, s->selfTestOk, 3);
    *p = '\0';
    Text_PrintLine(4, line);
}

static void DrawLuxAndTime(const DateTime *now, uint16_t lux)
{
    char line[LINE_BUFFER];
    char *p;

    p = PutText(line, "Lux ");
    p = PutUInt(p, lux, 5);
    p = PutText(p, " (pot)");
    *p = '\0';
    Text_PrintLine(6, line);

    p = PutUInt(line, now->date.year, 4);  *p++ = '-';
    p = PutUInt(p, now->date.month, 2);    *p++ = '-';
    p = PutUInt(p, now->date.day, 2);      *p++ = ' ';
    p = PutUInt(p, now->hour, 2);          *p++ = ':';
    p = PutUInt(p, now->minute, 2);        *p++ = ':';
    p = PutUInt(p, now->second, 2);
    *p = '\0';
    Text_PrintLine(7, line);
}

static void SetLed(StorageState state)
{
    switch (state) {
        case STORAGE_READY: SetRGBs(0, LED_LEVEL, 0); break;
        case STORAGE_ERROR: SetRGBs(LED_LEVEL, 0, 0); break;
        default:            SetRGBs(0, 0, 0);         break;
    }
}

static bool SameInfo(const StorageInfo *a, const StorageInfo *b)
{
    return a->state == b->state && a->lastError == b->lastError
        && a->fileioError == b->fileioError && a->fatType == b->fatType
        && a->mountCount == b->mountCount && a->selfTestOk == b->selfTestOk;
}

void UI_Init(void)
{
    SetColor(BLACK);
    ClearDevice();
    SetColor(WHITE);
    Text_PrintLine(0, "LUX LOGGER   UI STUB");
    infoValid = false;
    shownSecond = 0xFF;
}

void UI_Update(void)
{
    StorageInfo info;
    Storage_GetInfo(&info);
    if (!infoValid || !SameInfo(&info, &shownInfo)) {
        DrawStorage(&info);
        SetLed(info.state);
        shownInfo = info;
        infoValid = true;
    }

    // Lux and time: at most once per second (drawing a row takes ~10-20 ms).
    DateTime now;
    Clock_Now(&now);
    if (now.second != shownSecond) {
        DrawLuxAndTime(&now, Sensor_ReadLux());
        shownSecond = now.second;
    }
}
