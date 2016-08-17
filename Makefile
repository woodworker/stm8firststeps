SDCC = sdcc
STM8FLASH = sudo /home/woodworker/bin/stm8flash
STLINK=stlinkv2

CHIP = STM8S103 # STM8S003
CHIP_TYPE = STM8S103F3
CHIP_TYPE_LCASE  = $(shell echo $(CHIP_TYPE) | tr '[:upper:]' '[:lower:]')

CFLAGS = -lstm8 -mstm8 -L./libsrc/build/ -l./libsrc/stm8s_stdlib.a -I./libsrc/inc -D$(CHIP) -DUSE_STDPERIPH_DRIVER

MAIN_SOURCE = blinky
SOURCES = # lcd slider keypad

all: clean build

build: $(MAIN_SOURCE:=.ihx)

$(MAIN_SOURCE:=.ihx): $(MAIN_SOURCE:=.rel) $(SOURCES:=.rel)
	$(SDCC) $(CFLAGS) --out-fmt-ihx $(MAIN_SOURCE:=.rel) $(SOURCES:=.rel)

clean:
	rm -f *.ihx *.lk *.lst *.map *.rel *.rst *.sym *.asm

flash: $(MAIN_SOURCE:=.ihx)
	$(STM8FLASH) -c $(STLINK) -p $(CHIP_TYPE_LCASE) -w $(MAIN_SOURCE:=.ihx)

unlock:
	echo "00 00 ff 00 ff 00 ff 00 ff 00 ff" | xxd -r -p > factory_defaults.bin
	$(STM8FLASH) -c $(STLINK) -p $(CHIP_TYPE_LCASE) -s opt -w factory_defaults.bin
	rm factory_defaults.bin

%.rel: %.c
	$(SDCC) -c $(CFLAGS) $<

lib:
