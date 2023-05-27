FROM tidair/smurf-base:R2.0.0

# Install system tools
RUN apt-get update && apt-get install -y \
    cmake \
    libboost-all-dev \
    libbz2-dev \
    libzmq3-dev \
    python3-pyqt5 \
    python3-pyqt5.qtsvg \
 && rm -rf /var/lib/apt/lists/*

# PIP Packages
RUN pip3 install PyYAML Pyro4 parse click pyzmq packaging jsonpickle sqlalchemy serial
# Server gui crashing for PyDM versions >= 1.19.0.
RUN pip3 install pydm==1.18.2
# Upgrade pyqt5
RUN pip3 install pyqt5==5.15

# Install Rogue (An specific point in the the pre-release branch)
WORKDIR /usr/local/src
RUN git clone https://github.com/slaclab/rogue.git -b v4.11.10
WORKDIR rogue

# Apply patches

RUN mkdir build
WORKDIR build
RUN cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo -DROGUE_INSTALL=local .. && make -j4 install
ENV PYTHONPATH /usr/local/src/rogue/lib:${PYTHONPATH}
ENV PYTHONPATH /usr/local/src/rogue/python:${PYTHONPATH}
ENV ROGUE_DIR  /usr/local/src/rogue

# Setup PyDM environmental variables
ENV PYQTDESIGNERPATH       ${ROGUE_DIR}/python/pyrogue/pydm:${PYQTDESIGNERPATH}
ENV PYDM_DATA_PLUGINS_PATH ${ROGUE_DIR}/python/pyrogue/pydm/data_plugins
ENV PYDM_TOOLS_PATH        ${ROGUE_DIR}/python/pyrogue/pydm/tools

# Copy utility scripts
RUN mkdir -p /usr/local/src/rogue_utilities
COPY scripts/* /usr/local/src/rogue_utilities/
ENV PATH /usr/local/src/rogue_utilities:${PATH}
