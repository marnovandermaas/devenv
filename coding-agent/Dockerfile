FROM ubuntu:22.04

# Apt update and install packages:
# - curl to download installer
# - jq for status line
# - git to interact with repos
RUN apt update \
    && apt upgrade -y \
    && apt install -y curl \
    && apt install -y jq \
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
CMD ["claude","--permission-mode","auto"]

# Building container:
# podman build --tag 'coding-agent' .

# Add persistent home so that you only have to log in on the first session:
# podman volume create coding-agent-home

# Running container:
# podman run -it --rm --userns keep-id:uid=1000,gid=1000 --volume "$(pwd)":/workspace:rw,Z,U --volume coding-agent-home:/home/coag:rw,z --volume ~/podman/claude-code/:/etc/claude-code:ro localhost/coding-agent:latest
