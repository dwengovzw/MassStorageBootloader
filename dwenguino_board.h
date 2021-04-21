/*
 * dwenguinoBoard.h
 *
 *  Created on: Feb 17, 2021
 *      Author: Tom Neutens
 */

#ifndef DWENGUINO_BOARD_H_
#define DWENGUINO_BOARD_H_

#include <util/delay.h>

//	Constants
#define FALSE	    0
#define TRUE		!FALSE
#define HIGH		1
#define LOW			0
#define INPUT		0
#define OUTPUT		1

//	Data types
#define BYTE unsigned char

//	Pin assingments

//	LEDs

#define LEDS_DIR		DDRA
#define LEDS			PORTA

//	LCD display
#define LCD_DATA			PORTA
#define LCD_DATA_DIR		DDRA

#define LCD_BACKLIGHT_ON	PORTE |= 1<<3
#define LCD_BACKLIGHT_OFF	PORTE &= ~(1<<3)
#define LCD_BACKLIGHT_OUT	DDRE |= 1<<3
#define LCD_BACKLIGHT_IN	DDRE &= ~(1<<3)

#define LCD_RW_HIGH			PORTE |= 1<<1
#define LCD_RW_LOW			PORTE &= ~(1<<1)
#define LCD_RW_OUT			DDRE |= 1<<1

#define LCD_RS_HIGH			PORTE |= 1<<0
#define LCD_RS_LOW			PORTE &= ~(1<<0)
#define LCD_RS_OUT			DDRE |= 1<<0

#define LCD_EN_HIGH			PORTE |= 1<<2
#define LCD_EN_LOW			PORTE &= ~(1<<2)
#define LCD_EN_OUT			DDRE |= 1<<2


//	Servo connectors
#define SERVO1	PORTC0
#define SERVO2	PORTC1

//	Include libraries
#include <avr/io.h>
#include <util/delay.h>

#ifndef NO_LCD
#include "dwenguino_lcd.h"
#endif

/*
    @brief initializes the dwenguino board.
*/
void initBoard(void);

#endif	//DWENGUINO_BOARD_H_