#
#             LUFA Library
#     Copyright (C) Dean Camera, 2021.
#
#  dean [at] fourwalledcubicle [dot] com
#           www.lufa-lib.org
#
# --------------------------------------
#         LUFA Project Makefile.
# --------------------------------------

# Run "make help" for target help.

MCU          = at90usb646
ARCH         = AVR8
BOARD        = DWENGUINO
F_CPU        = 16000000
F_USB        = $(F_CPU)
OPTIMIZATION = s
TARGET       = BootloaderMassStorage
SRC          = $(TARGET).c dwenguino_lcd.c dwenguino_board.c Descriptors.c BootloaderAPI.c BootloaderAPITable.S Lib/SCSI.c Lib/VirtualFAT.c $(LUFA_SRC_USB) $(LUFA_SRC_USBCLASS)
LUFA_PATH    = ./LUFA
CC_FLAGS     = -DUSE_LUFA_CONFIG_HEADER -IConfig/ -DBOOT_START_ADDR=$(BOOT_START_OFFSET)
LD_FLAGS     = -Wl,--section-start=.text=$(BOOT_START_OFFSET) $(BOOT_API_LD_FLAGS)
LTO          = Y
AVRDUDE_PROGRAMMER = usbasp
AVRDUDE_PORT = usb
AVRDUDE_FLAGS = -U lfuse:w:0xff:m -U hfuse:w:0xd8:m -U efuse:w:0xfb:m

# Flash size and bootloader section sizes of the target, in KB. These must
# match the target's total FLASH size and the bootloader size set in the
# device's fuses.
FLASH_SIZE_KB         = 64
BOOT_SECTION_SIZE_KB  = 8

# Bootloader address calculation formulas
# Do not modify these macros, but rather modify the dependent values above.
CALC_ADDRESS_IN_HEX   = $(shell printf "0x%X" $$(( $(1) )) )
BOOT_START_OFFSET     = $(call CALC_ADDRESS_IN_HEX, ($(FLASH_SIZE_KB) - $(BOOT_SECTION_SIZE_KB)) * 1024 )
BOOT_SEC_OFFSET       = $(call CALC_ADDRESS_IN_HEX, ($(FLASH_SIZE_KB) * 1024) - ($(strip $(1))) )

$(info $(BOOT_START_OFFSET))

# Bootloader linker section flags for relocating the API table sections to
# known FLASH addresses - these should not normally be user-edited.
BOOT_SECTION_LD_FLAG  = -Wl,--section-start=$(strip $(1))=$(call BOOT_SEC_OFFSET, $(3)) -Wl,--undefined=$(strip $(2))
BOOT_API_LD_FLAGS     = $(call BOOT_SECTION_LD_FLAG, .apitable_trampolines, BootloaderAPI_Trampolines, 96)
BOOT_API_LD_FLAGS    += $(call BOOT_SECTION_LD_FLAG, .apitable_jumptable,   BootloaderAPI_JumpTable,   32)
BOOT_API_LD_FLAGS    += $(call BOOT_SECTION_LD_FLAG, .apitable_signatures,  BootloaderAPI_Signatures,  8)

# Check if the bootloader needs an AUX section, located before the real bootloader section to store some of the
# bootloader code. This is required for 32KB and smaller devices, where the actual bootloader is 8KB but the maximum
# bootloader section size is 4KB. The actual usable application space will be reduced by 6KB for these devices.
ifeq ($(BOOT_SECTION_SIZE_KB),8)
  $(info "--------------->>>Sufficient bootloader space")
  CC_FLAGS           += -DAUX_BOOT_SECTION_SIZE=0
else
  $(info "--------------->>>Extending boot section size")
  AUX_BOOT_SECTION_SIZE_KB = (8 - $(BOOT_SECTION_SIZE_KB))

  CC_FLAGS           += -DAUX_BOOT_SECTION_SIZE='($(AUX_BOOT_SECTION_SIZE_KB) * 1024)'
  LD_FLAGS           += -Wl,--section-start=.boot_aux=$(call BOOT_SEC_OFFSET, (($(BOOT_SECTION_SIZE_KB) + $(AUX_BOOT_SECTION_SIZE_KB)) * 1024 - 16))
  LD_FLAGS           += $(call BOOT_SECTION_LD_FLAG, .boot_aux_trampoline, Boot_AUX_Trampoline, ($(BOOT_SECTION_SIZE_KB) + $(AUX_BOOT_SECTION_SIZE_KB)) * 1024)
endif

# Default target
all:

# Include LUFA-specific DMBS extension modules
DMBS_LUFA_PATH ?= $(LUFA_PATH)/Build/LUFA
include $(DMBS_LUFA_PATH)/lufa-sources.mk
include $(DMBS_LUFA_PATH)/lufa-gcc.mk

# Include avrdude upload build target
include $(LUFA_PATH)/Build/lufa_avrdude.mk
include $(LUFA_PATH)/Build/lufa_core.mk
#include $(LUFA_PATH)/Build/lufa_build.mk

# Include common DMBS build system modules
DMBS_PATH      ?= $(LUFA_PATH)/Build/DMBS/DMBS
include $(DMBS_PATH)/core.mk
include $(DMBS_PATH)/cppcheck.mk
include $(DMBS_PATH)/doxygen.mk
include $(DMBS_PATH)/dfu.mk
include $(DMBS_PATH)/gcc.mk
include $(DMBS_PATH)/hid.mk

include $(DMBS_PATH)/avrdude.mk
include $(DMBS_PATH)/atprogram.mk
