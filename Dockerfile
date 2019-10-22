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
RUN pip3 install PyYAML Pyro4 parse click pyzmq packaging jsonpickle sqlalchemy serial pydm

# Install Rogue (An specific point in the the pre-release branch)
WORKDIR /usr/local/src
RUN git clone https://github.com/slaclab/rogue.git
WORKDIR rogue
RUN git checkout 381476afe3ea1738f6adc8488b1fd1f8bdd594fd

RUN mkdir build
WORKDIR build
RUN cmake -DCMAKE_BUILD_TYPE=Release -DROGUE_INSTALL=system ..
RUN make -j4 install
ENV ROGUE_DIR /usr/local
