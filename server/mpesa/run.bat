@echo off
REM Simple M-Pesa Backend Server Startup
REM This batch file works with standard Windows cmd.exe

cd /d "%~dp0"

echo.
echo ========================================
echo M-Pesa Backend Server Installation
echo ========================================
echo.

echo Step 1: Checking Node.js installation...
where node >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Node.js not found!
    echo Please install Node.js from https://nodejs.org/
    pause
    exit /b 1
)

echo Node.js found: 
node --version

echo.
echo Step 2: Installing dependencies...
echo.

REM Delete node_modules directory if it exists
if exist node_modules (
    echo Removing old node_modules folder...
    for /d %%G in (node_modules) do rmdir /s /q "%%G" 2>nul
)

REM Run npm install
call npm install

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ERROR: npm install failed!
    pause
    exit /b 1
)

echo.
echo Step 3: Starting M-Pesa Backend Server...
echo.
echo Firebase Credentials: serviceAccountKey.json
echo M-Pesa Environment: SANDBOX (from .env)
echo Server URL: http://192.168.1.66:8080
echo.
echo Press Ctrl+C to stop the server
echo.
echo ========================================
echo.

REM Start the server
call node index.js

REM If server exits, show message
echo.
echo Server stopped.
pause
