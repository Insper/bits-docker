FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update

RUN apt-get install -y curl build-essential git clang bison flex \
    libreadline-dev gawk tcl-dev libffi-dev git \
    graphviz xdot pkg-config python3 libboost-system-dev \
    libboost-python-dev libboost-filesystem-dev zlib1g-dev \
    wget unzip make g++ libftdi1-dev libhidapi-dev libudev-dev cmake \
	gzip libboost-all-dev libeigen3-dev liblzma-dev

RUN git clone https://github.com/YosysHQ/yosys yosys
WORKDIR /yosys
RUN make config-gcc; make -j$(nproc); make install

WORKDIR /
RUN git clone https://github.com/Ravenslofty/mistral mistral
WORKDIR /mistral
ENV MISTRAL_ROOT=/mistral

WORKDIR /
RUN git clone https://github.com/YosysHQ/nextpnr nextpnr
WORKDIR /nextpnr
RUN cmake . -DARCH=mistral -DMISTRAL_ROOT=$MISTRAL_ROOT; make -j$(nproc)
RUN make install

WORKDIR /
RUN git clone https://github.com/trabucayre/openFPGALoader openfpgaloader
WORKDIR /openfpgaloader
RUN cmake .; make -j$(nproc)
RUN make install

# Bits e Proc course Tools
WORKDIR /
run apt install -y python3.8
run wget https://bootstrap.pypa.io/get-pip.py
run python3.8 get-pip.py

ARG CACHEBUST=1
run pip3.8 install pytest
run pip3.8 install git+https://github.com/myhdl/myhdl.git@master
run pip3.8 install git+https://github.com/Insper/bits-e-proc-tools
run pip3.8 install git+https://github.com/insper-education/telemetry-pytest
