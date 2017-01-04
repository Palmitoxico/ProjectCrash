# Embedded Music Beat Detection

## Hardware

This project uses the STM32F4Discovery development board that includes a Cortex M4F microcontroller with 1MB of FLASH and 192KB of SRAM.

## How to build

### Software and Library Dependencies:

* make;
* arm-none-eabi-gcc (>= 4.9);
* arm-none-eabi-gdb (>= 7.2);
* arm-none-eabi-newlib;
* openocd (>= 0.8.0);
* bash (optional).

### Build and Upload to the target microcontroller:

Compile:

```$ make -j4```

Upload to the target (make sure that the STLINK debugger is connected to the host computer and OpenOCD is properly configured):

```$ make burn```

## How run the application

After uploading, reset the microcontroller and put the development board next to an audio source. After 4s the LD4 led of the developing board will start to blink with the beat of the music.
