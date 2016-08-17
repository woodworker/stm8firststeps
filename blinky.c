#include "stm8s.h"

int main() {
	int d;

	// Configure pins
    GPIO_DeInit(GPIOB);
	GPIO_Init(GPIOB, GPIO_PIN_5, GPIO_MODE_OUT_PP_LOW_FAST);
	// Loop
	do {
		GPIO_WriteReverse(GPIOB, GPIO_PIN_5);
		for(d = 0; d < 29000; d++) {
        }
	} while(1);
}
