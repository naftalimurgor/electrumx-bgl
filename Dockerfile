FROM python:3.10-slim

# Install build tools and LevelDB dev headers
RUN apt-get update && apt-get install -y \
    build-essential \
    libssl-dev \
    libevent-dev \
    libleveldb-dev \
    python3-dev \
    gcc \
    g++ \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /electrumx

# Copy and install requirements
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy rest of the app
COPY . .

# Expose ElectrumX ports
EXPOSE 50001 50002

# Start ElectrumX server
CMD ["python3", "-m", "electrumx.server.controller"]
