#!/usr/bin/env bash
# One-click start for n8n (macOS). Uses Docker if available, otherwise Node.js.
# Workflows in ./workflows/*.json are imported automatically on the first run.
cd "$(dirname "$0")"
URL="http://localhost:5678"

open_browser() {
  ( sleep 8; (xdg-open "$URL" || open "$URL") >/dev/null 2>&1 ) &
}

if command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
  echo "Starting n8n with Docker... (press Ctrl+C to stop; your data is kept)"
  open_browser
  TTY=""; [ -t 0 ] && TTY="-it"
  docker run $TTY --rm --name n8n -p 5678:5678 \
    -e GENERIC_TIMEZONE=Asia/Kolkata -e TZ=Asia/Kolkata \
    -v n8n_data:/home/node/.n8n \
    -v "$PWD/workflows:/workflows:ro" \
    --entrypoint sh docker.n8n.io/n8nio/n8n -c '
      M=/home/node/.n8n/.workflows_imported
      if [ ! -f "$M" ] && ls /workflows/*.json >/dev/null 2>&1; then
        echo "Importing workflows..."
        n8n import:workflow --separate --input=/workflows/ && touch "$M"
      fi
      exec n8n start'
elif command -v npx >/dev/null 2>&1; then
  echo "Docker not found. Starting n8n with Node.js... (press Ctrl+C to stop)"
  open_browser
  M="$HOME/.n8n/.workflows_imported"
  if [ ! -f "$M" ] && ls workflows/*.json >/dev/null 2>&1; then
    echo "Importing workflows..."
    npx --yes n8n import:workflow --separate --input=workflows/ && touch "$M"
  fi
  npx --yes n8n
else
  echo "Neither Docker nor Node.js is installed."
  echo "Install one of them, then run this again:"
  echo "  Docker:  https://www.docker.com/products/docker-desktop/"
  echo "  Node.js: https://nodejs.org"
  read -r -p "Press Enter to close..."
fi
