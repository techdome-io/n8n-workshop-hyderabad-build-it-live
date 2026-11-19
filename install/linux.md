# Install n8n on Linux

## Option A: Docker (recommended)
```bash
docker run -it --rm --name n8n -p 5678:5678 -v n8n_data:/home/node/.n8n docker.n8n.io/n8nio/n8n
```
If you get a permission error: `sudo usermod -aG docker $USER` and re-login.

## Option B: Node.js
```bash
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt-get install -y nodejs
npx n8n
```

Open http://localhost:5678
