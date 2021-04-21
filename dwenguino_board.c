/*
 * dwenguinoBoard.c
 *
 *  Created on: Feb 17, 2021
 *      Author: Tom Neutens
 */

#include "dwenguino_board.h"

void initBoard(void){

	//if LCD display is connected (default)
#ifndef	NO_LCD
	initLCD();
	clearLCD();
	backlightOff();
#endif

	//	Set buttons as inputs

    DDRC &= ~(1 << 6);
    DDRE &= ~(1 << 7);
    DDRE &= ~(1 << 6);
    DDRE &= ~(1 << 5);
    DDRE &= ~(1 << 4);

	//	Enalbe pullups for the switches

    PORTC |= (1 << 6);
    PORTE |= (1 << 7);
    PORTE |= (1 << 6);
    PORTE |= (1 << 5);
    PORTE |= (1 << 4);

	//	Set led pins as output

	LEDS_DIR = 0xff;	//LED pins as output
	LEDS = 0x00;		//Turn LEDs off






}