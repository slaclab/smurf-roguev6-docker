FROM tidair/smurf-base:R0.0.0

# Install system tools
RUN apt-get update && apt-get install -y \
    cmake \
    libboost-all-dev \
    libbz2-dev \
    libzmq3-dev \
    python3-pyqt5 \
 && rm -rf /var/lib/apt/lists/*

# PIP Packages
RUN pip3 install PyYAML Pyro4 parse click pyzmq packaging

#Install Rogue
WORKDIR /usr/local/src
RUN git clone https://github.com/slaclab/rogue.git -b v3.3.1
WORKDIR rogue
RUN mkdir build
WORKDIR build
RUN cmake .. -DROGUE_INSTALL=system
RUN make -j4 install
ENV ROGUE_DIR /usr/local
