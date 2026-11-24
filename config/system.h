/* system.h - header required by lib/mla_fileio
 *
 * The file system library includes "system.h". It only uses the clock values
 * from it, and only in the SD card driver, which we do not use. The values are
 * still correct so nobody copies wrong assumptions:
 *   PIC24FJ256GB106, 12 MHz crystal, 96 MHz PLL, CPDIV = 1:1 (CLKDIV = 0)
 *   -> system clock 32 MHz, instruction clock FCY = 16 MHz.
 */
#ifndef SYSTEM_H
#define SYSTEM_H

#include <stdint.h>
#include <stdbool.h>

#define SYS_CLK_FrequencySystemGet()        32000000UL
#define SYS_CLK_FrequencyPeripheralGet()    SYS_CLK_FrequencySystemGet()
#define SYS_CLK_FrequencyInstructionGet()   (SYS_CLK_FrequencySystemGet() / 2)

#endif // SYSTEM_H
