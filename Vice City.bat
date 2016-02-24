@echo off

set setdir=C:\Users\ENTER_USERNAME_HERE\Documents\GTA Vice City User Files
set intdir=C:\Users\ENTER_USERNAME_HERE\Documents\GTA Vice City User Files\int
set japdir=C:\Users\ENTER_USERNAME_HERE\Documents\GTA Vice City User Files\jp
set intmp3=D:\GTA Vice City\GTAMP3Randomizer.exe
set japmp3=D:\GTA Vice City Jap\GTAMP3Randomizer.exe

:START
cls
echo Vice City setup utility
echo 1. International version
echo 2. Japanese version
set /P v=Select version: 
if "%v%"=="1" GOTO INT
if "%v%"=="2" GOTO JAP
GOTO START

:INT
echo International version setup in progress
start "" "%intmp3%"
XCOPY "%intdir%" "%setdir%" /y
echo DONE
GOTO SLEEP

:JAP
echo Japanese version setup in progress
start "" "%japmp3%"
XCOPY "%japdir%" "%setdir%" /y
echo DONE
GOTO SLEEP

:SLEEP
cls
echo Type "1" when you're done playing
set /P ayy=Put it here m8: 
if "%ayy%"=="1" if "%v%"=="1" GOTO INT_KILL
if "%ayy%"=="1" if "%v%"=="2" GOTO JAP_KILL
GOTO SLEEP

:INT_KILL
MOVE "%setdir%\*.*" "%intdir%\"
GOTO END

:JAP_KILL
MOVE "%setdir%\*.*" "%japdir%\"
GOTO END

:END
taskkill /IM gtamp3randomizer.exe
exit