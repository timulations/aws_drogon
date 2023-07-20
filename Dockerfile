FROM amazonlinux:latest

RUN dnf install -y git
RUN dnf install -y gcc
RUN dnf install -y gcc-c++

RUN dnf install -y openssl
RUN dnf install -y openssl-devel

# build cmake from repo, default version is too low
RUN dnf install -y cmake

RUN git clone https://github.com/open-source-parsers/jsoncpp
WORKDIR jsoncpp
RUN mkdir build
WORKDIR build
RUN cmake ..
RUN make && make install
WORKDIR /

RUN dnf install -y libuuid-devel
RUN dnf install -y zlib-devel

# support databases and caches
RUN dnf install -y mariadb105
RUN dnf install -y mariadb105-devel

RUN dnf install -y sqlite 
RUN dnf install -y sqlite-devel

RUN dnf install -y redis6
RUN dnf install -y redis6-devel 

# build and install Drogon
RUN git clone https://github.com/drogonframework/drogon.git
WORKDIR drogon
RUN git submodule update --init
RUN mkdir build
WORKDIR build
RUN cmake ..
RUN make && make install
WORKDIR /

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV LD_LIBRARY_PATH=/usr/local/lib64

EXPOSE 80 8848
