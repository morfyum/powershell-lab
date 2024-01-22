@echo off
net session >nul 2>&1
if %errorLevel% == 0 (
    echo [FAIL] Adm1nistrat0r
) else (
    echo [PASS] Normal User
)
pause
exit