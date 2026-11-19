# n8n Workshop Hyderabad | Build It Live

Hands-on n8n workshop in Hyderabad. This repo has everything you need to follow along: install guides for Linux, macOS and Windows, plus the workflow JSONs we build live.

## Quick start (one click)

Download this repo (green **Code** button → **Download ZIP**, then unzip) and double-click the file for your system:

| System | File to double-click |
|---|---|
| Windows | `start-n8n.bat` |
| macOS | `start-n8n.command` (first time: right-click → Open) |
| Linux | `start-n8n.sh` (or run `./start-n8n.sh`) |

It starts n8n and opens http://localhost:5678 in your browser. It needs **Docker Desktop** or **Node.js** installed first (the script tells you if neither is found). Close the window or press Ctrl+C to stop; your workflows are kept.

## What's inside

```
├── README.md
├── start-n8n.bat       # Windows one-click
├── start-n8n.command   # macOS one-click
├── start-n8n.sh        # Linux one-click
├── install/
│   ├── linux.md
│   ├── macos.md
│   └── windows.md
├── workflows/          # importable workflow JSONs
├── docker-compose.yml  # optional, same on every OS
└── .env.example
```

## Before the workshop

1. Install n8n for your OS:
   - [Linux](install/linux.md)
   - [macOS](install/macos.md)
   - [Windows](install/windows.md)
2. Open http://localhost:5678 and create your owner account.
3. Confirm you see the empty workflow canvas. You're ready.

## Import the workflows

**UI:** Workflows → ⋯ menu → **Import from File** → pick a JSON from `workflows/`.

**CLI:**
```bash
n8n import:workflow --input=workflows/<file>.json
```

## Credentials

Workflow JSONs contain no credentials. After importing, open each node that shows a red warning and add your own credential (API key, OAuth, etc.). Each workflow's needs are listed in [workflows/README.md](workflows/README.md).

## Run it

1. Open the imported workflow.
2. Click **Execute workflow** to test.
3. Toggle **Active** when you want it to run on its own.

## Troubleshooting

| Problem | Fix |
|---|---|
| Port 5678 already in use | Stop the other process, or run with `-p 5679:5678` |
| `npx` / `node` not found | Install Node.js 20+ |
| Docker permission denied (Linux) | `sudo usermod -aG docker $USER`, then log out and in |
| Webhook URLs don't work from outside | Use a tunnel (`npx n8n start --tunnel`) for testing only |
| Credential warning on a node | Add your own credential, none are shipped in the JSON |

## License

MIT
