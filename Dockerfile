FROM tidair/smurf-base:R1.0.0

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
RUN git clone https://github.com/slaclab/rogue.git && cd rogue && git checkout 82723d993d72cc1cc65275e3bb2c12ddf5be75d1
WORKDIR /usr/local/src/rogue

RUN mkdir build
WORKDIR build
RUN cmake .. -DROGUE_INSTALL=system
RUN make -j4 install
ENV ROGUE_DIR /usr/local
