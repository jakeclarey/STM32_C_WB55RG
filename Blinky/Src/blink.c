
#include "blink.h"

void GPIO_Init(void)
{
  RCC->AHB2ENR |= 1 << 1; // turn on GPIOB clock (Nucleo-WB55RG)

  GPIOB->MODER &= ~(3 << (2 * 0)); // clear PB0 to input
  GPIOB->MODER |= 1 << (2 * 0);    // set PB0 to output

  GPIOB->MODER &= ~(3 << (2 * 1)); // clear PB1 to input
  GPIOB->MODER |= 1 << (2 * 1);    // set PB1 to output

  GPIOB->MODER &= ~(3 << (2 * 5)); // clear PB5 to input
  GPIOB->MODER |= 1 << (2 * 5);    // set PB5 to output
}

void SysTick_Init(void)
{
  SysTick->CTRL = 0;
  SysTick->LOAD = 0xFFFFFF;
  SysTick->VAL  = 0;
  SysTick->CTRL |= 1 | (1 << 2);
}

void delayMS(uint16_t ms)
{
  SysTick->LOAD = 4000 * (ms - 1);
  SysTick->VAL  = 0;
  while (!(SysTick->CTRL & (1 << 16))) {}
}
