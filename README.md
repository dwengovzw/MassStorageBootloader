## USB Massstorage bootloader for Dwenguino microcontroller platform

This repository contains bootloader code for the Dwenguino microcontroller enabling users to upload an AVR binaries by copying them to the emulated mass storage device. The bootloader is based on the MassStorage Bootloader in the [LUFA library](https://github.com/abcminiuser/lufa). 

This version of the bootloader is speciffically designed for the AVR AT90USB646 microcontroller and limits the functionallity offered by the original example from the LUFA library. It disables reading from the program memory, disables reading and writing of from/to the eprom memory, and always rewrites the the program memory after each file transfer. Consequently, the last transfered file is the data that is present in te program memory. 

### Dependencies

* gmake (installed by default on ubuntu)
* avrdude (sudo apt-get install gcc-avr binutils-avr avr-libc)

### Compilation instructions

* Clone/download this repository to your local machine.
* Download the LUFA library ([version 210130](https://github.com/abcminiuser/lufa/releases/tag/LUFA-210130)) from their [github page](https://github.com/abcminiuser/lufa).
* Copy the LUFA folder from the library to the root folder fo this repository.
* Run the *make* command from the root folder of the project to compile the code.

To upload the code to the microcontroller you need a compatible AVR programmer. The upload was tested with the USBASP (usbasp) as well as the AVRISP MKII (avrisp2). Update the AVRDUDE_PROGRAMMER setting in the makefile and run the command *make avrdude*.

### Requirements for binary file

The USB Massstorage bootloader enables programming .bin files using the standard USB file transfer protocol. Since we do not want users to be able to transfer incompatible files to the microcontroller, the .bin files have to be signed. The singature contains a set of signature bytes and the number of fat sectors the file needs to be stored. If the signature in the file matches the one set inside the bootloader, the bootloader accepts next transfered sectors to be written to the program memory. 

To sign your compiled arduino/dwenguino code you can run the shell script *package.sh* with the following parameters:

1. Signature file location (will be created)
2. Input hex file in intel format (.elf) (should exist).
3. Name of the output file. (will be created, this is the file you can upload to the Dwenguino Microcontroller with the USB Massstorage bootloader)
4. Name of the intermediate file 


The script can easliy be changed to automatically create the intermidiate files. However, we chose not to do this to allow us to specify them programmatically from our other applications.


