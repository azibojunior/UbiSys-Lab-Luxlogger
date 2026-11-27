/* TextDisplay.h - text output on the 128x64 OLED (shared helper)
 *
 * Added by part B for debug output (the starter kit offers no usable
 * breakpoints). Part C owns the user interface and may extend or replace
 * this module; please keep Text_PrintLine() working for debug screens.
 *
 * Layout: 8 text rows (0..7) of 8 pixels, 21 characters of 6 pixels per row.
 * Text_PrintLine() overwrites every pixel of its row (no separate clearing,
 * so no flicker). Drawing uses PutPixel() and takes roughly 10-20 ms per row,
 * so redraw only what changed.
 */
#ifndef TEXTDISPLAY_H
#define TEXTDISPLAY_H

#include <stdint.h>

#define TEXT_ROWS           8
#define TEXT_COLUMNS        21
#define TEXT_CHAR_WIDTH     6       // 5 pixels + 1 pixel spacing
#define TEXT_CHAR_HEIGHT    8       // 7 pixels + 1 pixel spacing

// Draws one character with its top-left corner at (x, y). Only the "on"
// pixels are set; the background is left unchanged.
void Text_DrawChar(int16_t x, int16_t y, char c);

// Draws a string starting at (x, y); stops at the right edge of the display.
void Text_DrawString(int16_t x, int16_t y, const char *text);

// Writes text into row 0..7, padded with spaces to the full display width.
// Every pixel of the row is written, so old content disappears.
void Text_PrintLine(uint8_t row, const char *text);

#endif // TEXTDISPLAY_H
