FROM ubuntu:bionic
WORKDIR /app
RUN sed -i 's/archive.ubuntu.com/free.nchc.org.tw/g' /etc/apt/sources.list
RUN apt update
RUN apt install -y software-properties-common
RUN add-apt-repository ppa:longsleep/golang-backports -y
RUN apt update -q
RUN apt install -y git wget curl
RUN apt install -y build-essential
RUN apt install -y make
RUN apt install -y cmake
RUN apt install -y patchelf
RUN apt install -y gcc-multilib
RUN apt install -y libncurses-dev
RUN apt install -y zlib1g-dev
RUN apt install -y golang-go
CMD ["make"]
