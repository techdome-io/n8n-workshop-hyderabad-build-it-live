@echo off
REM One-click start for n8n (Windows). Uses Docker if available, otherwise Node.js.
cd /d "%~dp0"
set URL=http://localhost:5678

docker info >nul 2>&1
if %errorlevel%==0 (
  echo Starting n8n with Docker... close this window or press Ctrl+C to stop. Your data is kept.
  start "" /b cmd /c "timeout /t 10 /nobreak >nul & start %URL%"
  docker run -it --rm --name n8n -p 5678:5678 -e GENERIC_TIMEZONE=Asia/Kolkata -e TZ=Asia/Kolkata -v n8n_data:/home/node/.n8n docker.n8n.io/n8nio/n8n
  goto :end
)

where npx >nul 2>&1
if %errorlevel%==0 (
  echo Docker not found. Starting n8n with Node.js... press Ctrl+C to stop.
  start "" /b cmd /c "timeout /t 10 /nobreak >nul & start %URL%"
  call npx --yes n8n
  goto :end
)

echo Neither Docker nor Node.js is installed.
echo Install one of them, then run this again:
echo   Docker:  https://www.docker.com/products/docker-desktop/
echo   Node.js: https://nodejs.org
:end
pause
