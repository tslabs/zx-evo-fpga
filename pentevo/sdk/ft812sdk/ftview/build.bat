set path=%path%;%SDCC%\bin\

if not exist obj md obj
del /q /s obj >nul

sdasz80 -o obj/crt0.rel src/crt0.s
if errorlevel 1 pause & exit

sdcc -Isrc -I../lib/sdk -I../lib/ft812 -I../lib/tsconf -I../lib/esp32 -I../../../esp32/src/main -mz80 --std-sdcc11 --opt-code-speed --no-std-crt0 obj/crt0.rel --code-loc 0x8003 --data-loc 0xAE00 src/main.c ../lib/ft812/ft812.lib ../lib/tsconf/ts.lib ../lib/sdk/sdk.lib -o obj/out.hex
if errorlevel 1 pause & exit
if exist obj/out.hex hex2bin obj/out.hex >nul

for %%i in (obj/out.bin) do set sz=%%~zi
set /a sz=(%sz% - 1) / 512 + 1

sdcc -DN_BLK0=%sz% -Isrc -I../lib/sdk -I../lib/ft812 -I../lib/tsconf --no-std-crt0 -mz80 --std-sdcc11 --opt-code-speed src/wc_h.c -o obj/hdr.hex
if errorlevel 1 pause & exit
if exist obj/hdr.hex hex2bin obj/hdr.hex >nul

copy /b obj\hdr.bin + obj\out.bin ftview.wmf >nul

REM imgcpy.exe ftview.wmf unreal\wc.img=c:\wc\ftview.wmf
REM if errorlevel 1 pause & exit

REM unreal\unreal
