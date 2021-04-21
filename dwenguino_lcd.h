/*
 * dwenguinoLCD.h
 *
 *  Created on: Feb 17, 2021
 *      Author: Tom Neutens
 */

#ifndef DWENGUINO_LCD_H_
#define DWENGUINO_LCD_H_


#include "dwenguino_board.h"
#include <avr/io.h>
#include <util/delay.h>
#include <stdlib.h>

//	Properties
#define LCD_WIDTH		16
#define LCD_HEIGHT		2
#define LCD_LASTLINE	(LCD_HEIGHT - 1)
#define LCD_LASTPOS		(LCD_WIDTH - 1)

//	Macro's
#define backlightOn()	(PORTE |= (1<<3))
#define backlightOff()	(PORTE &= ~(1<<3))

#define appendStringToLCD(message)	appendStringToLCD_((const char*)(message))

//	Functions

/*
    @brief Initializes the LCD communication.
*/
void initLCD(void);
/*
    @brief Clears the LCD screen.
*/
void clearLCD(void);

/*
    @brief Send a command to the LCD screen over PORTA.
    @param c The command to be sent.
*/
void commandLCD(const BYTE c);
/*
    @brief Set the cursor to a specific position.
    @param l line
    @param p position
*/
void setCursorLCD(BYTE l, BYTE p);

/*
    @brief print a character on the current cursor position and move the cursor.
    @param c the character to be printed.
*/
void appendCharToLCD(const char c);

/*
    @brief print a character to the LCD.
    @param s the character to be printed.
    @param l line
    @param p position
*/
void printCharToLCD(const char s, BYTE l, BYTE p);

/*
    @brief Print a char sequence on a specific position on the screen.
    @param message The char sequence to be printed.
    @param l line
    @param p position
*/
void printStringToLCD(char* message, BYTE l, BYTE p);

/*
    @brief print an integer to the LCD on the current cursor position.
    @param i The integer to be printed.
*/
void appendIntToLCD(int i);
/*
    @brief print an integer to the LCD on a specific position.
    @param i The integer to be printed.
    @param l line
    @param p position
*/
void printIntToLCD(int i, BYTE l, BYTE p);

//	Structures
/*
    @brief Contains the current cursor position.
*/
struct lcd_info_type{
	unsigned char line;
	unsigned char pos;
};

//	Keeps track of current line number and character position.
extern struct lcd_info_type lcd_info;

#endif /* DWENGUINO_LCD_H_ */