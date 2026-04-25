FROM mcr.microsoft.com/devcontainers/base:ubuntu

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        gcc \
        tar \
    && rm -rf /var/lib/apt/lists/*

COPY jik-release.env /tmp/devcontainer/jik-release.env
COPY scripts /tmp/devcontainer/scripts

RUN bash /tmp/devcontainer/scripts/install-jik-release.sh \
    && rm -rf /tmp/devcontainer
