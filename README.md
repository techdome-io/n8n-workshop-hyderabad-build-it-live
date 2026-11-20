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

What it does: starts n8n **2.48.7** using Docker (or Node.js if Docker isn't installed) and opens http://localhost:5678 in your browser. The **first time** it also:
- creates the two Data Tables for you (`leads` and `employee_requests`), so there is no CSV to upload
- imports the two starter workflows (Part 1 of each)

Close the window or press Ctrl+C to stop. Your data is kept.

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

> The manual route does **not** run the first-run setup. Create the tables yourself: Data Tables → create from CSV → upload `data/leads.csv` and `data/employee_requests.csv` (name them `leads` and `employee_requests`), and import the files in `workflows/start/` by hand. To get the automatic setup with Docker Compose, use `docker compose up -d` instead (it runs the same first-run script).

Per-OS details: [Linux](install/linux.md) · [macOS](install/macos.md) · [Windows](install/windows.md)

## 4. Build the workflows live

Two workflows, each built in 3 parts:

| Workflow | Part 1 (already imported) | Part 2 | Part 3 |
|---|---|---|---|
| **AI Lead Intelligence** | `workflows/start/1_lead_intelligence_...` | `workflows/next/lead-intelligence/2_...` | `workflows/next/lead-intelligence/3_...` |
| **Employee Request Router** | `workflows/start/1_employee_router_...` | `workflows/next/employee-router/2_...` | `workflows/next/employee-router/3_...` |

For each next part: open the JSON file, copy everything (Ctrl+A, Ctrl+C), click the canvas of your workflow and paste (Ctrl+V). Then connect the new nodes as the sticky note on that part says. (Parts 2 and 3 point at nodes from earlier parts, so they can't be imported as separate workflows.)

The Data Tables `leads` and `employee_requests` already exist (created automatically on first start).

## 5. Add credentials and run

Workflow JSONs contain no credentials. Open each node that shows a red warning and add your own:

| Node | What you need |
|---|---|
| **OpenAI Model** | Create an OpenAI credential with the **API key** and **Base URL** given at the workshop. Model: `gpt-5-mini`. |
| **Enrich Company - Apollo** | Disabled by default. Enable only if you have your own Apollo API key. |
| **Notify Sales - Slack** | Disabled by default. Enable after adding your own Slack credential and channel. |
| **Gmail nodes** (Employee Router) | Your own Gmail OAuth credential (see the sticky note in Part 2). Put your own email in the four queue nodes of Part 1. |

Then click **Execute workflow** to test, and toggle **Active** to run it automatically.

## What's inside

```
├── README.md
├── start-n8n.bat / .command / .sh   # one-click start (Windows / macOS / Linux)
├── setup/
│   ├── first-run.sh                 # runs on first start
│   └── setup-data-tables.json       # creates the leads + employee_requests tables
├── workflows/
│   ├── start/                       # Part 1 of each workflow (auto-imported)
│   └── next/                        # Parts 2 and 3 (paste in during the workshop)
├── data/                            # the two CSV templates (manual fallback)
├── install/                         # per-OS guides
└── docker-compose.yml               # optional
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
| Window says "Setup folder not shared with Docker" | Docker can't read the folder. Move the unzipped folder somewhere simple (e.g. your home folder, not Downloads/Desktop/OneDrive), allow Docker file access if macOS or Windows asks, and run again. Or create the tables by hand from `data/*.csv` |
| Starter workflows or data tables missing | The first-run setup runs only once. See "Start over" below |
| Webhook URLs don't work from outside | Use `npx n8n start --tunnel` for testing only |
| Credential warning on a node | Add your own credential, none are shipped in the JSON |

**Start over:** this deletes all your n8n data and runs the first-time setup again: `docker volume rm n8n_data`, then start n8n again.

## License

MIT
