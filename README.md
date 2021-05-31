## USB Massstorage bootloader for Dwenguino microcontroller platform

This repository contains bootloader code for the Dwenguino microcontroller enabling users to upload an AVR binaries by copying them to the emulated mass storage device. The bootloader is based on the MassStorage Bootloader in the [LUFA library](https://github.com/abcminiuser/lufa). 

This version of the bootloader is speciffically designed for the AVR AT90USB646 microcontroller and limits the functionallity offered by the original example from the LUFA library. It disables reading from the program memory, disables reading and writing of from/to the eprom memory, and always rewrites the the program memory after each file transfer. Consequently, the last transfered file is the data that is present in te program memory. 

### Dependencies

* LUFA library (version 210130)
* gmake
* avrdude

### Compilation instructions

* Clone/download this repository to your local machine.
* Download the LUFA library (version 210130) from their [github page](https://github.com/abcminiuser/lufa).
* Copy the LUFA folder from the library to the root folder fo this repository.
* Run the *make* command from the root folder of the project to compile the code.

To upload the code to the microcontroller you need a compatible AVR programmer. The upload was tested with the USBASP (usbasp) as well as the AVRISP MKII (avrisp2). Update the AVRDUDE_PROGRAMMER setting in the makefile and run the command *make avrdude*.
