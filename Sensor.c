/* Sensor.c - light sensor (part A)
 *
 * >>> STUB <<<  See Sensor.h. Replace this file with the real sensor driver.
 */
#include "Sensor.h"
#include "TouchSense.h"     // _potADC, filled by ReadCTMU()

void Sensor_Init(void)
{
    // Nothing to do: the potentiometer is read by ReadCTMU().
}

uint16_t Sensor_ReadLux(void)
{
    uint32_t lux = (uint32_t)_potADC * 64u;    // 10-bit ADC -> 0..65472
    if (lux > LUX_MAX) lux = LUX_MAX;
    return (uint16_t)lux;
}
