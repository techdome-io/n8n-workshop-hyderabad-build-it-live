@echo off
REM One-click start for n8n (Windows). Uses Docker if available, otherwise Node.js.
REM Workflows in .\workflows\*.json are imported automatically on the first run.
cd /d "%~dp0"
set URL=http://localhost:5678

docker info >nul 2>&1
if %errorlevel%==0 (
  echo Starting n8n with Docker... close this window or press Ctrl+C to stop. Your data is kept.
  start "" /b cmd /c "timeout /t 10 /nobreak >nul & start %URL%"
  docker run -it --rm --name n8n -p 5678:5678 -e GENERIC_TIMEZONE=Asia/Kolkata -e TZ=Asia/Kolkata -v n8n_data:/home/node/.n8n -v "%cd%\workflows:/workflows:ro" --entrypoint sh docker.n8n.io/n8nio/n8n -c "M=/home/node/.n8n/.workflows_imported; if [ ! -f $M ] && ls /workflows/*.json >/dev/null 2>&1; then echo Importing workflows...; n8n import:workflow --separate --input=/workflows/ && touch $M; fi; exec n8n start"
  goto :end
)

where npx >nul 2>&1
if %errorlevel%==0 (
  echo Docker not found. Starting n8n with Node.js... press Ctrl+C to stop.
  start "" /b cmd /c "timeout /t 10 /nobreak >nul & start %URL%"
  if not exist "%USERPROFILE%\.n8n\.workflows_imported" (
    if exist workflows\*.json (
      echo Importing workflows...
      call npx --yes n8n import:workflow --separate --input=workflows/ && (mkdir "%USERPROFILE%\.n8n" 2>nul & type nul > "%USERPROFILE%\.n8n\.workflows_imported")
    )
  )
  call npx --yes n8n
  goto :end
)

echo Neither Docker nor Node.js is installed.
echo Install one of them, then run this again:
echo   Docker:  https://www.docker.com/products/docker-desktop/
echo   Node.js: https://nodejs.org
:end
pause
