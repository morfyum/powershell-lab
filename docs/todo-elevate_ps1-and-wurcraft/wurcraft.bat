@echo off

:WURCRAFT_MENU
cls
:: Last command for debug: %last_command%
echo ================================================================================
echo *** Wurcraft v0.1 *** PWD: [ %cd% ]
echo ================================================================================
echo [ 0 ] Exit............................. [ 10 ] Option
echo [ 1 ] Test no root external cmd........ [ 11 ] Skip Win 11
echo [ 2 ] Test root external cmd........... [ 12 ] Option
echo [ 3 ] Test no root external powershell. [ 13 ] Option
echo [ 4 ] Test root external powershell.... [ 14 ] Option
echo [ 5 ] Option                            [ 15 ] Option
echo [ 6 ] Option                            [ 16 ] Option
echo [ 7 ] Option                            [ 17 ] Option
echo [ 8 ] Option                            [ 18 ] Option
echo [ 9 ] HP-UEFI Press F2................. [ 19 ] Option
echo ================================================================================
set "wurcraft_command="
set /p "wurcraft_command=Command <Enter>: "

if '%wurcraft_command%'=='0' goto COMMAND_EXIT
if /i '%wurcraft_command%'=='q' goto COMMAND_EXIT
if '%wurcraft_command%'=='1' goto TEST_ONE
if '%wurcraft_command%'=='2' goto TEST_TWO
if '%wurcraft_command%'=='3' goto TEST_THREE
if '%wurcraft_command%'=='4' goto TEST_FOUR
if '%wurcraft_command%'=='9' goto HP_UEFI
if '%wurcraft_command%'=='11' goto SKIP_WIN_NET
goto WURCRAFT_MENU


:COMMAND_EXIT
echo See you next time. Exit 0
pause >nul
exit


:TEST_ONE
cls
set "last_command=Test no-root External cmd"
cd tests
start cmd.exe /k "test_no_root_external_command.bat"
cd ..
goto WURCRAFT_MENU


:TEST_TWO
cls
set "last_command=Test root External cmd"
cd tests
powershell -Command "Start-Process 'test_root_external_command.bat' -Verb runAs"
cd ..
goto WURCRAFT_MENU


:TEST_THREE
cls
set "last_command=Test no-root External powershell"
cd tests
powershell -Command "Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted -Force"
powershell -Command "Start-Process powershell.exe -ArgumentList '.\test_no_root_external_powershell.ps1' "
cd ..
goto WURCRAFT_MENU


:TEST_FOUR
cls
set "last_command=Test root External powershell"
cd tests
powershell -Command "Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted -Force"
powershell -Command "Start-Process powershell.exe -ArgumentList '.\elevate-root.ps1' -WindowStyle hidden"
cd ..
goto WURCRAFT_MENU


:HP_UEFI
cls
set "last_command=HP-UEFI Press F2"
echo Shut down and go to Bios boot...
shutdown /s /fw /t 3


:SKIP_WIN_NET
cls 
set "last_command=Skip Win 11"
C:
oobe\bypassnro
goto WURCRAFT_MENU