// main.c - board check of my own project "display data by selecting days"
// Author: Azibo Junior Balgah
// Shows a title, which touch pads are touched, and a bar for the knob.
// delay() is copied from main.c of the professor's pic24fStarter.

#include <string.h>
#include "PIC24FStarter.h"   // only in main.c: it contains the #pragma config lines
#include "TextDisplay.h"

// wait for the given number of milliseconds (uses Timer1)
void delay(unsigned int milliseconds) {
    T1CONbits.TCKPS = 0b11;   // Timer1 counts slowly (prescaler 1:256)
    PR1 = 47;                 // the professor's value for one millisecond
    TMR1 = 0;
    T1CONbits.TON = 1;        // start Timer1
    unsigned int count = 0;
    while (count < milliseconds) {
        while (!IFS0bits.T1IF);   // wait until Timer1 says "time is up"
        IFS0bits.T1IF = 0;        // reset that flag
        count++;
    }
    T1CONbits.TON = 0;        // stop Timer1
}

int main(void) {
    char pads[11];                 // pad letters, for example "U - - - C "
    char oldPads[11] = "";         // what the display shows at the moment
    char bar[22];                  // the bar for the knob, up to 20 '#'
    uint8_t i, length;
    uint8_t oldLength = 255;       // 255 = "nothing drawn yet"

    INIT_CLOCK();                  // set the clock of the chip
    CTMUInit();                    // set up the touch pads and the knob
    RGBMapColorPins();             // set up the RGB LED
    RGBTurnOnLED();
    ResetDevice();                 // set up the OLED display
    ClearDevice();                 // make the display black

    Text_PrintLine(0, "DISPLAY DATA BY DAY");
    Text_PrintLine(1, "own project: OK");
    Text_PrintLine(3, "Touch the pads:");
    Text_PrintLine(5, "Turn the knob:");

    while (1) {                    // repeat forever
        ReadCTMU();                // read the pads into buttons[] and the knob into _potADC

        // 5th line: the letter of each touched pad, '-' for the others
        strcpy(pads, "- - - - - ");
        if (buttons[0]) pads[0] = 'U';   // up
        if (buttons[1]) pads[2] = 'R';   // right
        if (buttons[2]) pads[4] = 'D';   // down
        if (buttons[3]) pads[6] = 'L';   // left
        if (buttons[4]) pads[8] = 'C';   // center
        if (strcmp(pads, oldPads) != 0) {    // redraw only if something changed
            Text_PrintLine(4, pads);
            strcpy(oldPads, pads);
        }

        // 7th line: a bar of '#' that grows when you turn the knob up
        length = _potADC / 49;           // knob 0..1023 -> 0..20 characters
        if (length != oldLength) {       // redraw only if it changed
            for (i = 0; i < length; i++) {
                bar[i] = '#';
            }
            bar[length] = '\0';          // '\0' marks the end of the text
            Text_PrintLine(6, bar);
            oldLength = length;
        }

        // LED green while any pad is touched, off otherwise
        if (buttons[0] || buttons[1] || buttons[2] || buttons[3] || buttons[4]) {
            SetRGBs(0, 40, 0);
        } else {
            SetRGBs(0, 0, 0);
        }

        delay(10);                       // wait 10 ms, then repeat
    }
}
