echo off
cd .\src\
powershell.exe -executionPolicy Bypass -File  ".\main.ps1" -Command "Start-Process powershell.exe
pause