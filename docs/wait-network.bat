@echo off 

set "ip=127.0.0.1"

:AGAIN
ping -n 3 %ip% | find "TTL"
if errorlevel 1 ( 
    echo "Wait for connection..."
    GOTO AGAIN
) else (
    echo "Connection Established" 
    goto FUNCTION
)

:FUNCTION
echo "DOWNLOAD STUFF"
pause