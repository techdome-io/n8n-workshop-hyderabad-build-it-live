# n8n Workshop Hyderabad | Build It Live

Hands-on n8n workshop in Hyderabad. This repo has everything you need to follow along: install guides for Linux, macOS and Windows, plus the workflow JSONs we build live.

## 1. Before you start (requirements)

You need **one** of these two (Docker is easier for most people):

| Option | What to install | Notes |
|---|---|---|
| **A. Docker** (recommended) | [Docker Desktop](https://www.docker.com/products/docker-desktop/) (Windows / macOS) or [Docker Engine](https://docs.docker.com/engine/install/) (Linux) | Windows needs WSL2 (Docker Desktop sets it up). Start Docker and wait until it says "running". |
| **B. Node.js** | [Node.js](https://nodejs.org) **22 LTS** (20.19 or newer works; check [n8n's supported versions](https://docs.n8n.io/hosting/installation/npm/)) | Includes `npm` and `npx`. Check with `node -v`. |

Also needed:
- **Internet connection** for the first run (downloads n8n, about 1 GB for Docker).
- **4 GB RAM** free, 2 GB disk.
- **Port 5678 free.** Close anything else using it.
- A modern browser (Chrome, Edge, Firefox, Safari).
- Some workflows need your own accounts or API keys (listed in [workflows/README.md](workflows/README.md)).

Check your setup in a terminal (PowerShell on Windows):
```bash
docker --version     # Option A
node -v              # Option B
```

## 2. Get the files

Click the green **Code** button → **Download ZIP**, then unzip it. (Or `git clone https://github.com/techdome-io/n8n-workshop-hyderabad-build-it-live.git`.)

## 3. Start n8n: pick one method

### Method 1: One click (easiest)

Double-click the file for your system, inside the unzipped folder:

| System | File to double-click |
|---|---|
| Windows | `start-n8n.bat` |
| macOS | `start-n8n.command` (first time: right-click → Open) |
| Linux | `start-n8n.sh` (or run `./start-n8n.sh`) |

What it does: starts n8n using Docker (or Node.js if Docker isn't installed), opens http://localhost:5678 in your browser, and **automatically imports every workflow in `workflows/`** the first time. Close the window or press Ctrl+C to stop. Your data is kept.

### Method 2: Manual

Open a terminal in the unzipped folder (PowerShell on Windows).

**With Docker:**
```bash
docker run -it --rm --name n8n -p 5678:5678 \
  -e GENERIC_TIMEZONE=Asia/Kolkata -e TZ=Asia/Kolkata \
  -v n8n_data:/home/node/.n8n \
  docker.n8n.io/n8nio/n8n
```
(On Windows PowerShell, put it on one line without the `\`.)

Or with Docker Compose:
```bash
docker compose up -d      # start
docker compose down       # stop (data is kept)
```

**With Node.js:**
```bash
npx n8n
```

Then open http://localhost:5678 and create your owner account.

Per-OS details: [Linux](install/linux.md) · [macOS](install/macos.md) · [Windows](install/windows.md)

## 4. Import the workflows

- **One-click method:** already done for you on the first run.
- **Manual:** in n8n go to Workflows → **⋯** menu → **Import from File**, and pick a JSON from `workflows/`.
- **Manual via CLI:** `npx n8n import:workflow --separate --input=workflows/`

## 5. Add credentials and run

Workflow JSONs contain no credentials. Open each node that shows a red warning and add your own (API key, OAuth, etc.). Then click **Execute workflow** to test, and toggle **Active** to run it automatically.

## What's inside

```
├── README.md
├── start-n8n.bat       # Windows one-click
├── start-n8n.command   # macOS one-click
├── start-n8n.sh        # Linux one-click
├── install/            # per-OS guides
├── workflows/          # importable workflow JSONs
├── docker-compose.yml  # optional
└── .env.example
```

## Troubleshooting

| Problem | Fix |
|---|---|
| Script says neither Docker nor Node.js is found | Install one from section 1, then run it again |
| Docker is installed but the script uses Node / fails | Start Docker Desktop and wait until it's running |
| Port 5678 already in use | Stop the other process, or use `-p 5679:5678` and open `localhost:5679` |
| `node` / `npx` not found after installing | Close and reopen the terminal |
| Docker permission denied (Linux) | `sudo usermod -aG docker $USER`, then log out and in |
| macOS says the file can't be opened | Right-click → Open, or run `chmod +x start-n8n.command` |
| Windows SmartScreen warning on the `.bat` | Click **More info → Run anyway** |
| Workflows not imported | The import runs only once. See "Re-import" below |
| Webhook URLs don't work from outside | Use `npx n8n start --tunnel` for testing only |
| Credential warning on a node | Add your own credential, none are shipped in the JSON |

**Re-import:** import by hand from the n8n UI, or reset everything (this deletes your n8n data): `docker volume rm n8n_data`.

## License

MIT
