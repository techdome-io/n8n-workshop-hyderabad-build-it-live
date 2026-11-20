@echo off
REM One-click start for n8n (Windows). Uses Docker if available, otherwise Node.js.
REM On the first run it also creates the Data Tables and imports the starter workflows.
cd /d "%~dp0"
set URL=http://localhost:5678
if "%N8N_VERSION%"=="" set N8N_VERSION=2.48.7
if "%N8N_VOLUME%"=="" set N8N_VOLUME=n8n_data

docker info >nul 2>&1
if %errorlevel%==0 (
  echo Starting n8n %N8N_VERSION% with Docker... close this window or press Ctrl+C to stop. Your data is kept.
  start "" /b cmd /c "timeout /t 12 /nobreak >nul & start %URL%"
  docker run -it --rm --name n8n -p 5678:5678 -e GENERIC_TIMEZONE=Asia/Kolkata -e TZ=Asia/Kolkata -v %N8N_VOLUME%:/home/node/.n8n -v "%cd%\setup:/setup:ro" -v "%cd%\workflows:/workflows:ro" --entrypoint sh docker.n8n.io/n8nio/n8n:%N8N_VERSION% /setup/first-run.sh
  goto :end
)

where npx >nul 2>&1
if %errorlevel%==0 (
  echo Docker not found. Starting n8n %N8N_VERSION% with Node.js... press Ctrl+C to stop.
  start "" /b cmd /c "timeout /t 12 /nobreak >nul & start %URL%"
  if not exist "%USERPROFILE%\.n8n\.workshop_setup_done" (
    echo First run: preparing the workshop - data tables and starter workflows...
    call npx --yes n8n@%N8N_VERSION% import:workflow --input=setup/setup-data-tables.json
    if not errorlevel 1 call npx --yes n8n@%N8N_VERSION% publish:workflow --id=setupDataTables01
    if not errorlevel 1 call npx --yes n8n@%N8N_VERSION% import:workflow --separate --input=workflows/start/
    if not errorlevel 1 (
      mkdir "%USERPROFILE%\.n8n" 2>nul
      type nul > "%USERPROFILE%\.n8n\.workshop_setup_done"
    ) else (
      echo WARNING: workshop preparation failed. Import the files in setup and workflows by hand.
    )
  )
  call npx --yes n8n@%N8N_VERSION%
  goto :end
)

echo Neither Docker nor Node.js is installed.
echo Install one of them, then run this again:
echo   Docker:  https://www.docker.com/products/docker-desktop/
echo   Node.js: https://nodejs.org
:end
pause
