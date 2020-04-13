@ECHO OFF

SETLOCAL

:: Change these settings to suit your project and the port
:: that your Arduino is connected to

SET OUTPUT=myproject.elf
SET COMPORT=COM5

:: NOTE: You will need to manually add your .cpp files here
:: as they are created, so that GCC knows to compile them
SET FILES=main.cpp

:: Unfortunately, GCC and AVRDUDE (the uploading program for AVRs) decided
:: to use different strings to represent the same parts, because crazy.

:: Arduino Uno
REM SET GCC_MCU=atmega328p
REM SET AVRDUDE_MCU=m328p

:: Arduino Mega
SET GCC_MCU=atmega2560
SET AVRDUDE_MCU=m2560

:: Compiler flags for warning, optimizations, floating point library etc
SET FLAGS=-mmcu=%GCC_MCU% -g -Os --std=c++17 -lm -fshort-enums -ffunction-sections -fdata-sections -Wl,-gc-sections -Wall -Wextra -Wno-return-type -Wno-sized-deallocation -Wlogical-op -Wshadow
SET TOOLSPATH=C:\\Program Files (x86)\\Arduino\\hardware\\tools\\avr

:: Compile and show a summary of the binary output
"%TOOLSPATH%\\bin\\avr-g++" %FLAGS% -o %OUTPUT% %FILES%
"%TOOLSPATH%\\bin\\avr-size" -A -x %OUTPUT%
"%TOOLSPATH%\\bin\\avr-size" -C -x %OUTPUT%

:: Send it to the Arduino
"%TOOLSPATH%\\bin\\avrdude" "-C%TOOLSPATH%\\etc\\avrdude.conf" -v -p%AVRDUDE_MCU% -carduino -P%COMPORT% -b115200 -D -Uflash:w:%OUTPUT%:e

ENDLOCAL
