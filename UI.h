/* UI.h - screens, touch input and status LED (part C)
 *
 * >>> STUB <<<  Placeholder written by part B. It shows a plain status screen
 * (USB state, test-write counter, fake lux value, stub time) and sets the RGB
 * LED (green = stick ready, red = stick error, off = no stick), so the USB
 * code can be tested without breakpoints. Part C replaces UI.c with the real
 * user interface (day selection, graph, touch handling) and may change this
 * interface after agreeing with A (who calls it from main.c).
 *
 * Touch buttons are not used by the stub.
 */
#ifndef UI_H
#define UI_H

void UI_Init(void);     // call once after ResetDevice()
void UI_Update(void);   // call in every pass of the main loop; redraws only changes

#endif // UI_H
