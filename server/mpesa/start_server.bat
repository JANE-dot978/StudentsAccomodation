@echo off
REM M-Pesa Backend Server Startup
REM This batch file installs dependencies and starts the Node.js server

cd /d "%~dp0"
echo.
echo ========================================
echo M-Pesa Backend Server Startup
echo ========================================
echo.
echo Installing dependencies...
echo.

call npm install

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ERROR: npm install failed!
    echo Make sure Node.js is installed: https://nodejs.org/
    pause
    exit /b 1
)

echo.
echo Dependencies installed successfully!
echo.
echo Starting server on port 8080...
echo.

call node index.js

pause
