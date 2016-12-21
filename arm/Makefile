-include .prjconf.mk
PRJ_NAME   = BeatDetection
CC         = arm-none-eabi-gcc
SRC        = $(wildcard src/*.c)
ASRC       = $(wildcard src/*.s)
OBJ        = $(SRC:.c=.o) $(ASRC:.s=.o)
LIB        = lib/arm_math.a
OBJCOPY    = arm-none-eabi-objcopy
OBJDUMP    = arm-none-eabi-objdump
PROGRAMMER = openocd
DEVICE     = STM32F407xx
OPTIMIZE   = -Og
DBGFLAGS   = -g3
LDSCRIPT   = stm32f407vgtx.ld
CFLAGS     = -Wall -mcpu=cortex-m4 -mtune=cortex-M4 -mlittle-endian -mfloat-abi=hard -mfpu=fpv4-sp-d16  -mthumb -D ARM_MATH_CM4 -I inc/ -D $(DEVICE)
ASFLAGS    =  $(CFLAGS)
LDFLAGS    = -T $(LDSCRIPT) -Wl,--gc-sections --specs=nano.specs --specs=nosys.specs

.PHONY: all debug burn clean config rst fast fastd

ifeq ($(CONF), true)

all: CFLAGS += $(OPTIMIZE)
all: $(PRJ_NAME).elf

debug: CFLAGS += $(DBGFLAGS)
debug: $(PRJ_NAME).elf

burn:
	$(PROGRAMMER) $(PGFLAGS)

else

all: config
debug: config
burn: config

endif

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

config:
	./config

rst:

fast: all burn

fastd: debug burn
