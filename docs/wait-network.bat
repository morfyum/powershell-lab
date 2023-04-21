@echo off 

set "ip=127.0.0.1"

:AGAIN
ping -n 3 %ip% | find "TTL"
if errorlevel 1 ( 
    echo "Wait for connection..."
    GOTO AGAIN
) else (
    echo "Most fasza" 
    goto CPT_BATCH
)

:CPT_BATCH
echo "DOWNLOAD STUFF"
pause