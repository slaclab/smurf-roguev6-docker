FROM ubuntu:22.10

# Intall system utilities
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update && \
    apt-get install -y --no-install-recommends tzdata &&\
    apt-get install -y \
    wget \
    curl \
    git \
    vim \
    emacs \
    gnupg \
    net-tools \
    iputils-ping \
    ipmitool \
    cmake \
    python3 \
    python3-dev \
    python3-pip \
    libreadline6-dev \
    libboost-all-dev \
    libbz2-dev \
    libzmq3-dev \
    python3-pyqt5 \
    python3-pyqt5.qtsvg \
    gdb && \
    curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends git-lfs && \
    git lfs install && \
    rm -rf /var/lib/apt/lists/*

# PIP Packages
RUN pip3 install PyYAML parse click ipython pyzmq packaging matplotlib numpy p4p pyepics pydm jsonpickle sqlalchemy pyserial

# Add the IPMI package
WORKDIR /usr/local/src
ADD packages/IPMC.tar.gz .
ENV LD_LIBRARY_PATH /usr/local/src/IPMC/lib64:${LD_LIBRARY_PATH}
ENV PATH /usr/local/src/IPMC/bin/x86_64-linux-dbg:${PATH}

# Add the FirmwareLoader binary
RUN mkdir -p  /usr/local/src/FirmwareLoader/
ADD packages/FirmwareLoader.tar.gz /usr/local/src/FirmwareLoader/
ENV PATH /usr/local/src/FirmwareLoader:${PATH}

# Add the ProgramFPGA utility
ADD packages/ProgramFPGA /usr/local/src/ProgramFPGA
ENV PATH /usr/local/src/ProgramFPGA:${PATH}

# Install Smurf test apps
WORKDIR /usr/local/src
RUN git clone https://github.com/slaclab/smurftestapps.git

# Create the user cryo and the group smurf. Add the cryo user
# to the smurf group, as primary group. And create its home
# directory with the right permissions
RUN useradd -d /home/cryo -M cryo -u 1000 && \
    groupadd smurf -g 1001 && \
    usermod -aG smurf cryo && \
    usermod -g smurf cryo && \
    mkdir /home/cryo && \
    chown cryo:smurf /home/cryo

# Install Rogue
WORKDIR /usr/local/src
RUN git clone https://github.com/slaclab/rogue.git -b rogue_v6 &&\
    mkdir rogue/build
WORKDIR rogue/build
RUN cmake .. -DROGUE_INSTALL=system && \
    make -j4 install && \
    echo /usr/local/lib >> /etc/ld.so.conf.d/rogue_epics.conf && \
    ldconfig
ENV PYQTDESIGNERPATH /usr/local/lib/python3.10/dist-packages/pyrogue/pydm
ENV PYDM_DATA_PLUGINS_PATH /usr/local/lib/python3.10/dist-packages/pyrogue/pydm/data_plugins
ENV PYDM_TOOLS_PATH /usr/local/lib/python3.10/dist-packages/pyrogue/pydm/tools

# Copy utility scripts
COPY scripts/* /usr/local/bin/
ENV PATH /usr/local/bin:${PATH}

# Set the work directory to the root
WORKDIR /

