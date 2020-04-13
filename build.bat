@ECHO OFF

SETLOCAL

:: Change these settings to suit your project and the port
:: that your Arduino is connected to
SET OUTPUT=myproject.elf
SET COMPORT=COM5

:: NOTE: You will need to manually add your .cpp files here
:: as they are created, so that GCC knows to compile them
SET FILES=main.cpp

:: Add the subfolders here for any libraries for which you need
:: to easily reference the include files
SET INCLUDE_DIRS=-Isubfolder/ -Iothersubfolder/

:: Unfortunately, GCC and AVRDUDE (the uploading program for AVRs) decided
:: to use different strings to represent the same parts, because crazy.

:: Arduino Uno
REM SET GCC_MCU=atmega328p
REM SET AVRDUDE_MCU=m328p

:: Arduino Mega
SET GCC_MCU=atmega2560
SET AVRDUDE_MCU=m2560

:: Path to the AVR tools folder (not the enclosed 'bin' folder)
SET TOOLSPATH=C:\\Program Files (x86)\\Arduino\\hardware\\tools\\avr

:: Compiler flags for warning, optimizations, floating point library etc
SET FLAGS=-mmcu=%GCC_MCU% -g -Os --std=c++17 -lm -fshort-enums -ffunction-sections -fdata-sections -Wl,-gc-sections -Wall -Wextra -Wno-return-type -Wno-sized-deallocation -Wlogical-op -Wshadow

:: Compile and show a summary of the binary output
"%TOOLSPATH%\\bin\\avr-g++" %FLAGS% %INCLUDE_DIRS% -o %OUTPUT% %FILES% || goto :error
"%TOOLSPATH%\\bin\\avr-size" -A -x %OUTPUT% || goto :error
"%TOOLSPATH%\\bin\\avr-size" -C -x %OUTPUT% || goto :error

:: Send it to the Arduino
"%TOOLSPATH%\\bin\\avrdude" "-C%TOOLSPATH%\\etc\\avrdude.conf" -v -p%AVRDUDE_MCU% -carduino -P%COMPORT% -b115200 -D -Uflash:w:%OUTPUT%:e  || goto :error

ENDLOCAL

goto :EOF

:error
echo ******************** Failed with error #%errorlevel% ********************
exit /b %errorlevel%
