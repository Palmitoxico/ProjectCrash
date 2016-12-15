PRJ_NAME   = Template
CC         = arm-none-eabi-gcc
SRC        = $(wildcard src/*.c)
ASRC       = $(wildcard src/*.s)
OBJ        = $(SRC:.c=.o) $(ASRC:.s=.o)
OBJCOPY    = arm-none-eabi-objcopy
OBJDUMP    = arm-none-eabi-objdump
PROGRAMMER = openocd
PGFLAGS    = -f interface/stlink-v2.cfg -f target/stm32f4x.cfg -c "program $(PRJ_NAME).elf verify reset" -c shutdown
DEVICE     = STM32F407xx
OPTIMIZE   = -Og
DBGFLAGS   = -g3
LDSCRIPT   = stm32f407vgtx.ld
CFLAGS     = -Wall -mcpu=cortex-m4 -mlittle-endian -mfloat-abi=hard -mfpu=fpv4-sp-d16  -mthumb -I inc/ -D $(DEVICE)
ASFLAGS    =  $(CFLAGS)
LDFLAGS    = -T $(LDSCRIPT) -Wl,--gc-sections --specs=nano.specs --specs=nosys.specs

all: CFLAGS += $(OPTIMIZE)
all: $(PRJ_NAME).elf

debug: CFLAGS += $(DBGFLAGS)
debug: $(PRJ_NAME).elf

$(PRJ_NAME).elf: $(OBJ)
	$(CC) $(CFLAGS) $(OBJ) -o $@ $(LDFLAGS)
	$(OBJCOPY) -O ihex $(PRJ_NAME).elf $(PRJ_NAME).hex
	$(OBJCOPY) -O binary $(PRJ_NAME).elf $(PRJ_NAME).bin
	arm-none-eabi-size $(PRJ_NAME).elf

.c.o:
	$(CC) -c $(CFLAGS) $< -o $@

.s.o:
	$(CC) -c $(ASFLAGS) $< -o $@

clean:
	rm -f $(OBJ) *.map *.elf *.hex

burn:
	$(PROGRAMMER) $(PGFLAGS)

rst:

fast: all burn

fastd: debug burn
