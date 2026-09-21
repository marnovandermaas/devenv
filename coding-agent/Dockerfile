FROM ubuntu:22.04

# Apt update and install git.
RUN apt update \
    && apt upgrade -y \
    && apt install -y curl \
    && apt install -y git \
    && apt install -y npm

# Install as root, then relocate to a system path.
RUN curl -fsSL https://claude.ai/install.sh | bash \
    && cp /root/.local/bin/claude /usr/local/bin/claude \
    && chmod 755 /usr/local/bin/claude \
    && rm -rf /root/.local
RUN which claude

RUN useradd --create-home --uid 1000 --base-dir /home coag
USER coag

WORKDIR /workspace

# Enter claude
CMD ["claude"]

# Building container:
# podman build --tag 'coding-agent' .

# Add API key:
# podman volume create coding-agent-home

# Running container:
# podman run -it --rm --volume "$(pwd)":/workspace:rw,Z --volume coding-agent-home:/home/coag:rw,z localhost/coding-agent:latest
