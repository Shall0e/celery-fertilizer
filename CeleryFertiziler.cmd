@echo off
:: Check for administrative permissions
net session >nul 2>&1
if %errorLevel% == 0 (
    goto :admin
) else (
    echo Requesting administrative privileges...
    powershell -Command "Start-Process '%~0' -Verb runAs"
    exit
)

:admin
:: Your script path
set scriptPath="C:\path\to\your\script.ps1"
:: Run the PowerShell script
powershell.exe -File "%~dp0GUI.ps1"