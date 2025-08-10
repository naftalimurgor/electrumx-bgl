# ElectrumX BGL — Python Electrum Server for Bitgesell

Quickly spin up a Bitgesell Electrumx server ✨

<img src="logo.png" height="50%" width="100%" />

```
License: MIT  
Original Author: Neil Booth  
Current Maintainers: Sevault Wallet Maintainers, murgornaftali[at]gmail.com  
Language: Python (>= 3.10)
```

This project is a fork of [kyuupichan/electrumx](https://github.com/kyuupichan/electrumx) with added support for **Bitgesell**.

ElectrumX allows users to run their own Electrum server. It connects to a full node and indexes the blockchain, allowing efficient querying of address history. The server can be exposed publicly and joined to the global Electrum network via peer discovery.

As of May 2020, a significant portion of the public Electrum network runs ElectrumX.

---

## 📚 Documentation

See [ElectrumX ReadTheDocs](https://electrumx-spesmilo.readthedocs.io).

---

## 🚀 Deployment

This ElectrumX implementation currently powers the [Bitgesell Explorer](https://bgl.sevaultwallet.com).

You can deploy it with **Docker** or as a **systemd service**.

---

## ✅ 1. `electrumx.conf`

Save this as `/etc/electrumx.conf` or bind-mount into Docker:

```ini
COIN = Bitgesell
NET = mainnet

# Bitgesell node RPC
DAEMON_URL = http://rpcuser:rpcpassword@host:port/

# ElectrumX DB directory
DB_DIRECTORY = /electrumx/db

# Networking
TCP_PORT = 50001
SSL_PORT = 50002
HOST = 0.0.0.0

# Performance and Limits
COST_SOFT_LIMIT = 0
COST_HARD_LIMIT = 0
MAX_SEND = 10000000
MAX_SESSIONS = 100
BANNER_FILE = /electrumx/banner

# Logging
LOG_LEVEL = info
```

---

## ✅ 2. `Dockerfile`

Place this in the root of the ElectrumX fork:

```sh
FROM python:3.10-slim

RUN apt-get update && apt-get install -y \
    build-essential \
    libssl-dev \
    libevent-dev \
    libleveldb-dev \
    python3-dev \
    gcc \
    g++ \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

WORKDIR /app

EXPOSE 50001 50002

CMD ["start"]

```

---

## ✅ 3. Build & Run with Docker

```bash
docker build -t electrumx-bgl .
```

Run the container:

```bash
docker run -d \
  --name electrumx-bgl \
  -p 50001:50001 \
  -p 50002:50002 \
  -v $HOME/electrumx/db:/electrumx/db \
  -v $HOME/electrumx/banner:/electrumx/banner \
  -v $HOME/electrumx/electrumx.conf:/etc/electrumx.conf \
  --restart always \
  electrumx-bgl
```

---

## ✅ 4. `start-electrumx.sh` (Systemd Startup Script)

Save this script:

```bash
#!/bin/bash

# Activate virtual environment
source "$(pwd)/venv/bin/activate"

# --- Core ElectrumX Settings ---
export COIN=Bitgesell
export ELECTRUMX_NETWORK=mainnet

# Bitgesell Node URL
export DAEMON_URL=http://localuser:rpcpassword@HOST:PORT

# Database directory
export DB_DIRECTORY="$(pwd)/db"
export SERVICES=tcp://0.0.0.0:50001

# --- Memory Optimization ---
export DB_CACHE=400MB
export CACHE_MB=50
export MAX_SEND=1000000
export REORG_LIMIT=50
export BATCHES=10

# Logging
export LOG_LEVEL=info

# Run ElectrumX
python3 electrumx_server
```

Make executable:

```bash
chmod +x start-electrumx.sh
```

---

## ✅ 5. `systemd` Service File

Create `/etc/systemd/system/electrumx.service`:

```ini
[Unit]
Description=ElectrumX Server (Bitgesell)
After=network.target

[Service]
User=your-username
Group=your-username
ExecStart=/path/to/start-electrumx.sh
Restart=always
RestartSec=5
Environment=PYTHONUNBUFFERED=1
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=electrumx

[Install]
WantedBy=multi-user.target
```

Enable and start:

```bash
sudo systemctl daemon-reload
sudo systemctl enable electrumx
sudo systemctl start electrumx
```

---

## 🧪 Testing the Server

Check if TCP port is open:

```bash
nc your-vps-ip 50001
```

Send JSON request:

```json
{"id":1,"method":"server.version","params":["2.9.0", "1.4"]}
```

Expected response:

```json
{"id":1,"result":["ElectrumX X.Y.Z", "1.4"]}
```