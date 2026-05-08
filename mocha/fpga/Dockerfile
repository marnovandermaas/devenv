# Dockerfile for running Vivado
# Tested on 2021.1
FROM rockylinux:8.9

# Install dependencies
RUN dnf update -y && dnf clean all
RUN dnf install -y iproute

#General Packages
RUN dnf install -y systemd-libs
RUN dnf install -y util-linux
RUN dnf install -y libuuid
RUN dnf install -y libselinux
RUN dnf install -y pcre2
RUN dnf install -y graphviz
RUN dnf install -y redhat-lsb-core
RUN dnf install -y openssl
RUN dnf install -y libXScrnSaver
RUN dnf install -y xorg-x11-utils
# Vitis Tools prerequisite libraries
RUN dnf install -y gcc
RUN dnf install -y gcc-c++
RUN dnf install -y git
RUN dnf install -y compat-openssl10
# X virtual framebuffer (for GUI apps in headless environments)
RUN dnf install -y xorg-x11-server-Xvfb

# SDK needs python
RUN dnf install -y python3.12
RUN dnf install -y python3.12-pip

# Vitis fix immediate exit on launch
RUN dnf install -y at-spi2-atk
RUN dnf install -y gtk3
RUN dnf install -y mesa-libgbm
RUN dnf install -y alsa-lib

# Install fonts
RUN dnf install -y xorg-x11-fonts-\*
RUN dnf install -y dejavu-\*-fonts
RUN dnf install -y liberation-\*fonts
RUN fc-cache -v

# Network debug tools
RUN dnf install -y iputils bind-utils

# Change user
RUN useradd -m -d /home/mvdmaas -s /bin/bash --uid 1000 mvdmaas

# RUN mkdir /nix
# RUN chown 1000 /nix
# RUN chgrp 100 /nix

# RUN curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install > /tmp/nix_install.sh
# RUN sh /tmp/nix_install.sh --daemon --yes

# RUN chown 1000 -R /nix

# Set working dir
RUN mkdir /work
RUN chown 1000 -R /work --verbose
RUN chgrp 1000 -R /work --verbose
WORKDIR /work

# Change user
USER 1000:1000

# RUN mkdir /home/ray/.config

# Mocha build packages
RUN python3 -m pip install --upgrade pip
RUN pip3 install \
    "anytree==2.8.0" \
    "hjson==3.1.0" \
    "wheel==0.41.2" \
    "pyserial==3.5" \
    "pydantic>=2.8.2,<3" \
    "jinja2>=3.1.6,<4" \
    "semantic-version>=2.10.0,<3" \
    "pycryptodome>=3.23.0,<4" \
    "tabulate>=0.9.0,<0.10" \
    "setuptools>=80.9.0" \
    "packaging>=25.0" \
    "mako>=1.2" \
    "mistletoe==0.9.0" \
    "peakrdl-systemrdl >= 1.0" \
    "rdl2ot>=0.4" \
    "fusesoc==2.4.3" \
    "pyright>=1.1.403" \
    "ruff>=0.9.6" \
    "reuse>=5.0.2" \
    "pytest>=8.4.1" \
    "twine>=6.1.0" \
    "dvsim>=1.33" \
    "svgwrite>=1.4.3" \
    "pyelftools>=0.32"

# RUN mkdir /home/ray/.config/nix
# RUN echo 'extra-experimental-features = flakes nix-command' > /home/ray/.config/nix/nix.conf
# RUN echo 'substituters = https://nix-cache.lowrisc.org/public/ https://cache.nixos.org/' >> /home/ray/.config/nix/nix.conf
# RUN echo 'trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= nix-cache.lowrisc.org-public-1:O6JLD0yXzaJDPiQW1meVu32JIDViuaPtGDfjlOopU7o=' >> /home/ray/.config/nix/nix.conf
# RUN echo 'trusted-substituters =' >> /home/ray/.config/nix/nix.conf
# RUN echo 'trusted-users = root root @sudo ray' >> /home/ray/.config/nix/nix.conf

# RUN source /etc/bashrc && nix develop github:lowRISC/mocha --no-write-lock-file
# RUN source nix develop github:lowRISC/mocha --no-write-lock-file

# Set up PATH
ENV XILINX_VIVADO="/nas/lowrisc/tools/xilinx/Vivado/2021.1"
ENV PATH="/nas/lowrisc/tools/xilinx/Vivado/2021.1/bin:$PATH"

# Vivado license server
ENV XILINXD_LICENSE_FILE="2100@xilinx-license.services.lowrisc.dev"

# Run bash
ENTRYPOINT ["bash"]

# Run the following commands:
# podman build --tag vivado-env:latest
# podman run -it -v /nas/lowrisc/tools:/nas/lowrisc/tools:ro -v /home/mvdmaas/repos/mocha:/work:U --rm localhost/vivado-env:latest
