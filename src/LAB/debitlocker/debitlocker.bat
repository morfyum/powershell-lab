echo off
cd .\src\
powershell.exe -ExecutionPolicy RemoteSigned -File .\main.ps1
::powershell.exe -executionpolicy Bypass -File  ".\main.ps1" -Command "Start-Process powershell.exe"