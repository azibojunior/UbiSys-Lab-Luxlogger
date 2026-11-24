/* Sensor.h - light sensor (part A)
 *
 * >>> STUB <<<  Placeholder written by part B so the rest of the system can
 * be developed before the real sensor is connected. Part A replaces Sensor.c
 * with the real driver but should keep this interface.
 *
 * Stub behaviour: uses the potentiometer as a fake light sensor.
 * 0..1023 from the ADC is scaled to 0..65472 "lux".
 * Precondition: ReadCTMU() is called regularly in the main loop, because it
 * also reads the potentiometer into _potADC (see TouchSense.c).
 */
#ifndef SENSOR_H
#define SENSOR_H

#include "LuxLogger.h"

void     Sensor_Init(void);
uint16_t Sensor_ReadLux(void);  // 0..LUX_MAX, never LUX_NONE

#endif // SENSOR_H
