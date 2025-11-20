FROM ubuntu:22.04

# Apt update and install git.
RUN apt update \
    && apt upgrade -y \
    && apt install -y git

# Install modules.
RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime \
    && DEBIAN_FRONTEND=noninteractive apt install -y tzdata \
    && dpkg-reconfigure --frontend noninteractive tzdata \
    && apt install -y environment-modules

# Clone Spike repository.
RUN apt install -y build-essential device-tree-compiler \
    && git clone https://github.com/lowRISC/riscv-isa-sim.git \
    && cd riscv-isa-sim \
    && git checkout ibex_cosim \
    && mkdir install \
    && export SPIKE_INSTALL_DIR=$PWD/install \
    && mkdir build \
    && cd build \
    && ../configure --enable-commitlog --enable-misaligned --prefix=$SPIKE_INSTALL_DIR \
    && make \
    && make install

# Get RISC-V toolchain.
RUN apt install -y wget \
    && wget https://github.com/lowRISC/lowrisc-toolchains/releases/download/20250710-1/lowrisc-toolchain-rv32imcb-x86_64-20250710-1.tar.xz \
    && tar xf lowrisc-toolchain-rv32imcb-x86_64-20250710-1.tar.xz \
    && mv lowrisc-toolchain-rv32imcb-x86_64-20250710-1 toolchain

# Dependencies for dev shell.
RUN apt install -y csh ksh libxrender1 libsm6 libxtst6 libxi6 \
    && apt install -y pkg-config

# Clone Ibex repository.
RUN git clone -b pmp_lsb https://github.com/marnovandermaas/ibex.git
WORKDIR ibex

# Python virtual environment.
RUN apt install -y python-is-python3 python3-venv \
    && python -m venv .venv \
    && . .venv/bin/activate \
    && pip install -r python-requirements.txt

# Create setup shell.
RUN touch setup.sh \
    #&& echo "source .venv/bin/activate" >> setup.sh \
    && echo "source /etc/profile.d/modules.sh" >> setup.sh \
    && echo "export CDS_LIC_FILE=5280@license.servers.lowrisc.org" >> setup.sh \
    && echo "export MODULEPATH=/nas/lowrisc/tools/modulefilesexport MODULEPATH=/nas/lowrisc/tools/modulefiles" >> setup.sh \
    && echo "export SPIKE_PATH=/riscv-isa-sim/install/bin" >> setup.sh \
    && echo "export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/riscv-isa-sim/install/lib/pkgconfig" >> setup.sh \
    #&& echo "module load cadence/xcelium/latest" >> setup.sh \
    && echo "export PATH=$PATH:/toolchain/bin" >> setup.sh \
    && echo "export RISCV_GCC=riscv32-unknown-elf-gcc" >> setup.sh \
    && echo "export RISCV_OBJCOPY=riscv32-unknown-elf-objcopy" >> setup.sh

# Enter shell.
ENV SHELL /bin/bash
CMD bash

# Building container:
# podman build --tag 'ibex-dv' .

# Running container:
# podman run -it -v /nas/lowrisc/tools:/nas/lowrisc/tools:ro --rm localhost/ibex-dv:latest

# Inside the container run:
# source setup.sh
# source .venv/bin/activate
# module load cadence/xcelium/latest
# cd dv/uvm/core_ibex
# make --keep-going IBEX_CONFIG=opentitan SIMULATOR=xlm ISS=spike TEST=riscv_pmp_basic_test WAVES=0 ITERATIONS=1
