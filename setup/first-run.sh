#!/bin/sh
# Runs inside the n8n container on every start.
# First time only: creates the Data Tables (leads, employee_requests) and loads the starter workflows.
M=/home/node/.n8n/.workshop_setup_done
if [ ! -f "$M" ]; then
  echo "First run: preparing the workshop (data tables + starter workflows)..."
  if n8n import:workflow --input=/setup/setup-data-tables.json \
     && n8n publish:workflow --id=setupDataTables01 \
     && { ls /workflows/start/*.json >/dev/null 2>&1 && n8n import:workflow --separate --input=/workflows/start/ || true; }; then
    touch "$M"
    echo "Workshop preparation done."
  else
    echo "WARNING: workshop preparation failed; you can import files from setup/ and workflows/ by hand."
  fi
fi
exec n8n start
