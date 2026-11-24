/* TextDisplay.c - text output on the 128x64 OLED (shared helper), see TextDisplay.h */
#include "TextDisplay.h"
#include "SH1101A.h"
#include "Font5x7.h"

#define FIRST_CHAR  32      // ' '
#define LAST_CHAR   129     // last umlaut, see Font5x7.c

static const uint8_t *Glyph(char c)
{
    uint8_t code = (uint8_t)c;
    if (code < FIRST_CHAR || code > LAST_CHAR) {
        code = '?';
    }
    return Font5x7[code - FIRST_CHAR];
}

// Draws one 6x8 character cell. If opaque, "off" pixels are written black.
static void DrawCell(int16_t x, int16_t y, char c, uint8_t opaque)
{
    const uint8_t *glyph = Glyph(c);
    uint8_t savedColor = _color;

    for (int16_t col = 0; col < TEXT_CHAR_WIDTH; col++) {
        int16_t px = x + col;
        if (px < 0 || px >= DISP_HOR_RESOLUTION) continue;  // PutPixel has no bounds check
        uint8_t bits = (col < 5) ? glyph[col] : 0x00;       // column 5 = spacing
        for (int16_t row = 0; row < TEXT_CHAR_HEIGHT; row++) {
            int16_t py = y + row;
            if (py < 0 || py >= DISP_VER_RESOLUTION) continue;
            if (bits & (1u << row)) {
                SetColor(savedColor);
                PutPixel(px, py);
            } else if (opaque) {
                SetColor(BLACK);
                PutPixel(px, py);
            }
        }
    }
    SetColor(savedColor);
}

void Text_DrawChar(int16_t x, int16_t y, char c)
{
    DrawCell(x, y, c, 0);
}

void Text_DrawString(int16_t x, int16_t y, const char *text)
{
    while (*text && x < DISP_HOR_RESOLUTION) {
        DrawCell(x, y, *text++, 0);
        x += TEXT_CHAR_WIDTH;
    }
}

void Text_PrintLine(uint8_t row, const char *text)
{
    if (row >= TEXT_ROWS) return;

    uint8_t savedColor = _color;
    SetColor(WHITE);
    int16_t y = (int16_t)row * TEXT_CHAR_HEIGHT;
    for (uint8_t i = 0; i < TEXT_COLUMNS; i++) {
        char c = (*text) ? *text++ : ' ';
        DrawCell((int16_t)i * TEXT_CHAR_WIDTH, y, c, 1);
    }
    // 21 * 6 = 126 pixels: clear the last 2 columns of the row as well.
    SetColor(BLACK);
    for (int16_t x = TEXT_COLUMNS * TEXT_CHAR_WIDTH; x < DISP_HOR_RESOLUTION; x++) {
        for (int16_t r = 0; r < TEXT_CHAR_HEIGHT; r++) {
            PutPixel(x, y + r);
        }
    }
    SetColor(savedColor);
}
