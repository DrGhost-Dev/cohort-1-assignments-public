FROM ghcr.io/foundry-rs/foundry:stable

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Otherwise, the installation below will fail
USER root

# Update and install necessary packages
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    bash \
    jq \
    git \
    build-essential \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js and npm (using NodeSource repository for latest LTS)
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

# Create a non-root user to avoid permission issues
RUN useradd -m -s /bin/bash deployer && \
    mkdir -p /app && \
    chown -R deployer:deployer /app

# Set working directory
WORKDIR /app

COPY entrypoint.sh .
COPY extract-addresses.js .
# Switch to non-root user
# 스크립트에 실행 권한 부여
RUN chmod +x entrypoint.sh

# 컨테이너 시작 시 실행될 명령어 지정
ENTRYPOINT ["./entrypoint.sh"]