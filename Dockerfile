FROM ubuntu:latest
RUN apt update \
	&& apt upgrade -y \
	&& apt install -y build-essential flex bison libssl-dev libelf-dev bc dwarves python3 git \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

RUN cd /root \
	&& git clone --depth=1 https://github.com/microsoft/WSL2-Linux-Kernel.git

WORKDIR /root/WSL2-Linux-Kernel