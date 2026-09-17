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

# Vivado needs a language pack.
RUN apt install -y language-pack-en \
    && locale-gen en_US \
    && update-locale LANG=en_US

# Install Vivado dependencies.
RUN apt update \
    && apt upgrade -y \
    && apt install -y libtinfo5

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
# podman build --tag 'sunburst' .

# Running container:
# podman run -it -v /nas/lowrisc/tools:/nas/lowrisc/tools:ro -v /home/mvdmaas/repos/sunburst-chip:/sunburst-chip:rw --rm localhost/sunburst:latest

# Inside the container run:
# source setup.sh
# cd sunburst-chip
# uv venv
# uv sync --all-extras
# source .venv/bin/activate
# module load xilinx/vivado/latest
# fusesoc --cores-root=. run --target=synth --setup --build lowrisc:sunburst:top_chip_sonata_xl
