FROM ubuntu:22.04

# Apt update and install packages:
# - bubblewrap and socat for sandboxing
# - curl to download installer
# - jq for status line
# - git to interact with repos
# - xz needed for Nix
RUN apt update \
    && apt upgrade -y \
    && apt install -y bubblewrap \
    && apt install -y curl \
    && apt install -y gtkwave \
    && apt install -y jq \
    && apt install -y git \
    && apt install -y socat \
    && apt install -y xz-utils

# Install as root, then relocate to a system path.
RUN curl -fsSL https://claude.ai/install.sh | bash \
    && cp /root/.local/bin/claude /usr/local/bin/claude \
    && chmod 755 /usr/local/bin/claude \
    && rm -rf /root/.local

# Create coag user and switch to it.
RUN useradd --create-home --uid 1000 --base-dir /home coag
RUN mkdir -m 0755 /nix && chown coag /nix
USER coag

# Install Nix in single-user mode.
RUN curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install | sh -s -- --no-daemon
RUN mkdir -p /home/coag/.config/nix
RUN echo "experimental-features = nix-command flakes" > /home/coag/.config/nix/nix.conf

WORKDIR /workspace

# Enter claude in auto mode.
CMD ["claude", "--permission-mode", "auto"]

# Building container:
# podman build --tag 'coding-agent' .

# Add persistent home so that you only have to log in on the first session:
# podman volume create coding-agent-home

# Running container:
# podman run -it --rm --userns keep-id:uid=1000,gid=1000 --volume "$(pwd)":/workspace:rw,Z,U --volume "$(pwd)/.git":/workspace/.git:ro --volume coding-agent-home:/home/coag/.claude:rw,z --volume ~/podman/claude.json:/home/coag/.claude.json:rw,z --volume ~/podman/claude-code/:/etc/claude-code:ro --cap-drop=ALL --security-opt no-new-privileges localhost/coding-agent:latest
