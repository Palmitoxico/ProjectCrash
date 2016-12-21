PRJ_NAME   = BeatDetection
CC         = arm-none-eabi-gcc
SRC        = $(wildcard src/*.c)
ASRC       = $(wildcard src/*.s)
OBJ        = $(SRC:.c=.o) $(ASRC:.s=.o)
LIB        = lib/arm_math.a
OBJCOPY    = arm-none-eabi-objcopy
OBJDUMP    = arm-none-eabi-objdump
PROGRAMMER = openocd
PGFLAGS    = -f interface/stlink-v2.cfg -f target/stm32f4x.cfg -c "program $(PRJ_NAME).elf verify reset" -c shutdown
DEVICE     = STM32F407xx
OPTIMIZE   = -Og
DBGFLAGS   = -g3
LDSCRIPT   = stm32f407vgtx.ld
CFLAGS     = -Wall -mcpu=cortex-m4 -mtune=cortex-M4 -mlittle-endian -mfloat-abi=hard -mfpu=fpv4-sp-d16  -mthumb -D ARM_MATH_CM4 -I inc/ -D $(DEVICE)
ASFLAGS    =  $(CFLAGS)
LDFLAGS    = -T $(LDSCRIPT) -Wl,--gc-sections --specs=nano.specs --specs=nosys.specs

all: CFLAGS += $(OPTIMIZE)
all: $(PRJ_NAME).elf

debug: CFLAGS += $(DBGFLAGS)
debug: $(PRJ_NAME).elf

$(PRJ_NAME).elf: $(LIB) $(OBJ)
	$(CC) $(CFLAGS) $(OBJ) $(LIB) -o $@ $(LDFLAGS)
	arm-none-eabi-size $(PRJ_NAME).elf

$(LIB):
	$(MAKE) -C lib

.c.o:
	$(CC) -c $(CFLAGS) $< -o $@

.s.o:
	$(CC) -c $(ASFLAGS) $< -o $@

clean:
	$(MAKE) clean -C lib
	rm -f $(OBJ) *.map *.elf *.hex

burn:
	$(PROGRAMMER) $(PGFLAGS)

rst:

fast: all burn

fastd: debug burn
