#!/usr/bin/env bash
# One-click start for n8n (Linux). Uses Docker if available, otherwise Node.js.
# On the first run it also creates the Data Tables and imports the starter workflows.
cd "$(dirname "$0")"
URL="http://localhost:5678"
V="${N8N_VERSION:-2.48.7}"          # n8n version this workshop was tested on
VOL="${N8N_VOLUME:-n8n_data}"       # Docker volume that keeps your data

open_browser() {
  ( sleep 10; (xdg-open "$URL" || open "$URL") >/dev/null 2>&1 ) &
}

if command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
  echo "Starting n8n $V with Docker... (press Ctrl+C to stop; your data is kept)"
  open_browser
  TTY=""; [ -t 0 ] && TTY="-it"
  docker run $TTY --rm --name n8n -p 5678:5678 \
    -e GENERIC_TIMEZONE=Asia/Kolkata -e TZ=Asia/Kolkata \
    -v "$VOL":/home/node/.n8n \
    -v "$PWD/setup:/setup:ro" \
    -v "$PWD/event-workflows:/event-workflows:ro" \
    --entrypoint sh "docker.n8n.io/n8nio/n8n:$V" -c 'if [ -f /setup/first-run.sh ]; then sh /setup/first-run.sh; else echo "Setup folder not shared with Docker - starting n8n without first-run setup."; exec n8n start; fi'
elif command -v npx >/dev/null 2>&1; then
  echo "Docker not found. Starting n8n $V with Node.js... (press Ctrl+C to stop)"
  open_browser
  M="$HOME/.n8n/.workshop_setup_done"
  if [ ! -f "$M" ]; then
    echo "First run: preparing the workshop (data tables + starter workflows)..."
    ok=1
    npx --yes "n8n@$V" import:workflow --input=setup/setup-data-tables.json \
      && npx --yes "n8n@$V" publish:workflow --id=setupDataTables01 || ok=0
    for f in event-workflows/*/1_*.json; do
      [ -f "$f" ] || continue
      npx --yes "n8n@$V" import:workflow --input="$f" || ok=0
    done
    if [ "$ok" = 1 ]; then
      mkdir -p "$HOME/.n8n" && touch "$M"
    else
      echo "WARNING: workshop preparation failed; import the files in setup/ and event-workflows/ by hand."
    fi
  fi
  npx --yes "n8n@$V"
else
  echo "Neither Docker nor Node.js is installed."
  echo "Install one of them, then run this again:"
  echo "  Docker:  https://docs.docker.com/engine/install/"
  echo "  Node.js: https://nodejs.org"
  read -r -p "Press Enter to close..."
fi
