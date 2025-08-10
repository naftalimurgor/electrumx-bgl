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

# Copy ElectrumX code and startup script
COPY . .
COPY start-electrumx.sh /usr/local/bin/start-electrumx.sh
RUN chmod +x /usr/local/bin/start-electrumx.sh

EXPOSE 50001 50002

ENTRYPOINT ["start-electrumx.sh"]
