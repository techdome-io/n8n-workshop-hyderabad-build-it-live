# Install n8n on Windows

Use **PowerShell**.

## Option A: Docker Desktop (needs WSL2)
Install [Docker Desktop](https://www.docker.com/products/docker-desktop/) with the WSL2 backend, then:
```powershell
docker run -it --rm --name n8n -p 5678:5678 -v n8n_data:/home/node/.n8n docker.n8n.io/n8nio/n8n
```

## Option B: Node.js
Install Node.js 20+ LTS from https://nodejs.org, then:
```powershell
npx n8n
```

Open http://localhost:5678
