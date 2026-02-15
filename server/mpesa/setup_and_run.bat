@echo off
REM Clean install of all dependencies and start server
setlocal enabledelayedexpansion

cd /d "%~dp0"

echo.
echo ========================================
echo M-Pesa Backend Server - Clean Install
echo ========================================
echo.

REM Remove old node_modules if exists
if exist node_modules (
    echo Removing old node_modules...
    rmdir /s /q node_modules >nul 2>&1
)

echo.
echo Installing fresh dependencies...
echo This may take a few minutes...
echo.

REM Install all dependencies
npm install

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ERROR: npm install failed!
    echo.
    echo Possible solutions:
    echo 1. Make sure Node.js is installed: https://nodejs.org/
    echo 2. Try running as Administrator
    echo 3. Check your internet connection
    echo.
    pause
    exit /b 1
)

echo.
echo ========================================
echo Dependencies installed successfully!
echo ========================================
echo.
echo Installed packages:
npm list --depth=0
echo.
echo Starting M-Pesa Backend Server...
echo Server will run on: http://192.168.1.66:8080
echo.
echo Press Ctrl+C to stop the server
echo.

REM Start the server
node index.js

pause
