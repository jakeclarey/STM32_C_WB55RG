/* Author: Jacob Clarey
 * Date: 3/20/2024
 * Description: Setting up for Nucleo-WB55RG programming. Basic LD1-3 blink.
 * program. Notes: Works as of 3/20/2024
 */

#include "blink.h"
#include <stm32wb55xx.h>

#define EVEN_DELAY 183

int main(void)
{
  GPIO_Init();
  SysTick_Init();
  while (1)
  {
    GPIOB->ODR ^= 1U << 1;
    delayMS(EVEN_DELAY);
    GPIOB->ODR ^= 1U << 0;
    delayMS(EVEN_DELAY);
    GPIOB->ODR ^= 1U << 5;
    delayMS(EVEN_DELAY);
  } // while(1)
} // main(void)

/* EOF */
