#!/usr/bin/env bash
# One-click start for n8n (Linux). Uses Docker if available, otherwise Node.js.
cd "$(dirname "$0")"
URL="http://localhost:5678"

open_browser() {
  ( sleep 8; (xdg-open "$URL" || open "$URL") >/dev/null 2>&1 ) &
}

if command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
  echo "Starting n8n with Docker... (press Ctrl+C to stop; your data is kept)"
  open_browser
  docker run -it --rm --name n8n -p 5678:5678 \
    -e GENERIC_TIMEZONE=Asia/Kolkata -e TZ=Asia/Kolkata \
    -v n8n_data:/home/node/.n8n docker.n8n.io/n8nio/n8n
elif command -v npx >/dev/null 2>&1; then
  echo "Docker not found. Starting n8n with Node.js... (press Ctrl+C to stop)"
  open_browser
  npx --yes n8n
else
  echo "Neither Docker nor Node.js is installed."
  echo "Install one of them, then run this again:"
  echo "  Docker:  https://docs.docker.com/engine/install/"
  echo "  Node.js: https://nodejs.org"
  read -r -p "Press Enter to close..."
fi
