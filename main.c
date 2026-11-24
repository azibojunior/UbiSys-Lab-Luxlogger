/* main.c - lux logger main loop (owner: part A, integration)
 *
 * Based on main.c of pic24fStarter by kvl@eti.uni-siegen.de (July 2025):
 * delay() is unchanged, the circle demo was replaced by the module calls.
 *
 * Current state (week 1 of part B): the loop runs the USB stack and the stub
 * status screen. Logging one sample per minute is part A's next step (see TODO).
 */

#include "PIC24FStarter.h"      // only here: contains the #pragma config lines
#include "LuxLogger.h"
#include "Clock.h"
#include "Sensor.h"
#include "Storage.h"
#include "UI.h"

void delay(unsigned int milliseconds) {
    T1CONbits.TCKPS = 0b11; // Prescale 1:256
    PR1 = 47; TMR1 = 0; // Reset timer counter
    T1CONbits.TON = 1; // Turn on Timer1
    unsigned int count = 0;
    while (count < milliseconds) {
        while (!IFS0bits.T1IF); // Wait for Timer1 interrupt flag
        IFS0bits.T1IF = 0; // Clear Timer1 interrupt flag
        count++;
    }
    T1CONbits.TON = 0; // Turn off Timer1
}

int main(void) {
    INIT_CLOCK();       // 96 MHz PLL: also provides the 48 MHz USB clock
    CTMUInit();         // touch pads + potentiometer
    RGBMapColorPins();
    RGBTurnOnLED();
    ResetDevice();      // OLED

    Clock_Init();       // before Storage_Init(): files get time stamps
    Sensor_Init();
    UI_Init();
    Storage_Init();     // switches on USB host mode (VBUS)

    while (1) {
        ReadCTMU();         // touch buttons[] and potentiometer _potADC
        Storage_Tasks();    // USB host stack: must run in every pass
        UI_Update();

        // TODO (A): once per minute build a LuxSample from Clock_Now() and
        // Sensor_ReadLux() and pass it to Storage_Append() (works from week 2).

        delay(10);          // same loop pace as the original demo (touch filter)
    }
}
