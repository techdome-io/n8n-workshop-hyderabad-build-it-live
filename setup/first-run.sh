#!/bin/sh
# Runs inside the n8n container on every start.
# First time only: creates the Data Tables (leads, employee_requests) and imports Part 1 of each event workflow.
M=/home/node/.n8n/.workshop_setup_done
if [ ! -f "$M" ]; then
  echo "First run: preparing the workshop (data tables + starter workflows)..."
  ok=1
  n8n import:workflow --input=/setup/setup-data-tables.json && n8n publish:workflow --id=setupDataTables01 || ok=0
  for f in /event-workflows/*/1_*.json; do
    [ -f "$f" ] || continue
    n8n import:workflow --input="$f" || ok=0
  done
  if [ "$ok" = 1 ]; then
    touch "$M"
    echo "Workshop preparation done."
  else
    echo "WARNING: workshop preparation had errors; you can import the files in setup/ and event-workflows/ by hand."
  fi
fi
exec n8n start
