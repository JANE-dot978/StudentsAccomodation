@echo off
REM Start M-Pesa Payment Backend Server
REM Run this batch file to start the Node.js server on port 8080

cd /d %~dp0server\mpesa
node index.js
pause
