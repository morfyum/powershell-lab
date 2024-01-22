@echo off
net session >nul 2>&1
if %errorLevel% == 0 (
    echo [PASS] Adm1nistrat0r
) else (
    echo [FAIL] Not adm1nistrat0r
)
pause