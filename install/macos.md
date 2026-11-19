# Install n8n on macOS

## Option A: Docker Desktop
Install [Docker Desktop](https://www.docker.com/products/docker-desktop/), then:
```bash
docker run -it --rm --name n8n -p 5678:5678 -v n8n_data:/home/node/.n8n docker.n8n.io/n8nio/n8n
```

## Option B: Node.js
```bash
brew install node
npx n8n
```

Open http://localhost:5678
