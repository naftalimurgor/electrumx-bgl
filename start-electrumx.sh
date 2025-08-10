#!/bin/bash

# Activate virtual environment
source "$(pwd)/venv/bin/activate/path/to/electrumx-bgl"

# --- Core ElectrumX Settings ---
export COIN=Bitgesell
export ELECTRUMX_NETWORK=mainnet
export DAEMON_URL=http://localuser:rpcpassword@198.96.88.103:8455
export DB_DIRECTORY="$(pwd)/db"
export SERVICES=tcp://0.0.0.0:50001

# --- Memory Optimization ---
export DB_CACHE=400MB       # Limit DB cache size
export CACHE_MB=50          # Smaller in-memory UTXO/hist cache
export MAX_SEND=1000000     # Limit RPC send size
export REORG_LIMIT=50       # Limit block reorg depth
export BATCHES=10           # Smaller sync batches

# Logging
export LOG_LEVEL=info

# Run ElectrumX
python3 electrumx_server
