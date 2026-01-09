FROM ubuntu:22.04

# Apt update and install git.
RUN apt update \
    && apt upgrade -y \
    && apt install -y git \
    && apt install -y build-essential \
    && apt install -y vim

# Install modules.
RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime \
    && DEBIAN_FRONTEND=noninteractive apt install -y tzdata \
    && dpkg-reconfigure --frontend noninteractive tzdata \
    && apt install -y environment-modules

# Dependencies for dev shell.
RUN apt install -y csh ksh libxrender1 libsm6 libxtst6 libxi6 \
    && apt install -y pkg-config

# Python virtual environment.
RUN apt install -y python3 curl \
    && curl -LsSf https://astral.sh/uv/install.sh | sh

# Create setup shell.
RUN touch setup.sh \
    #&& echo "source .venv/bin/activate" >> setup.sh \
    && echo "source /etc/profile.d/modules.sh" >> setup.sh \
    && echo "export CDS_LIC_FILE=5280@license.servers.lowrisc.org" >> setup.sh \
    && echo "export MODULEPATH=/nas/lowrisc/tools/modulefilesexport MODULEPATH=/nas/lowrisc/tools/modulefiles" >> setup.sh \
    && echo "export PATH=/root/.local/bin:$PATH" . setup.sh

# Enter shell.
ENV SHELL /bin/bash
CMD bash

# Building container:
# podman build --tag 'mocha' .

# Running container:
# podman run -it -v /nas/lowrisc/tools:/nas/lowrisc/tools:ro -v /home/mvdmaas/repos/mocha:/mocha:rw --rm localhost/mocha:latest

# Inside the container run:
# source setup.sh
# cd mocha
# uv venv
# uv sync --all-extras
# source .venv/bin/activate
# module load cadence/xcelium/latest
# dvsim hw/vendor/lowrisc_ip/ip/uart/dv/uart_sim_cfg.hjson -i uart_smoke -r 1 --tool xcelium
