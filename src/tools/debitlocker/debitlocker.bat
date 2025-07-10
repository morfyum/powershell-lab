echo off
cd .\src\
powershell.exe -ExecutionPolicy RemoteSigned -File .\start.ps1
::powershell.exe -executionpolicy Bypass -File  ".\start.ps1" -Command "Start-Process powershell.exe"