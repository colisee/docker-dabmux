# Build odr-audioenc
FROM ubuntu:22.04 AS builder
ARG  URL_BASE=https://github.com/Opendigitalradio
ARG  SOFTWARE=ODR-DabMux/archive/refs/tags
ARG  VERSION=v4.2.1
ENV  DEBIAN_FRONTEND=noninteractive
## Update system
RUN  apt-get update \
     && apt-get upgrade --yes
## Install build packages
RUN  apt-get install --yes \
          autoconf \
          build-essential \
          curl \
          pkg-config
## Install development libraries and build
RUN  apt-get install --yes \
          libboost-system-dev \
          libcurl4-openssl-dev \
          libzmq3-dev \
     && cd /root \
     && curl -L ${URL_BASE}/${SOFTWARE}/${VERSION}.tar.gz | tar -xz \
     && cd ODR* \
     && ./bootstrap.sh \
     && ./configure \
     && make \
     && make install 

# Build the final image
FROM ubuntu:22.04
ENV  DEBIAN_FRONTEND=noninteractive
## Update system
RUN  apt-get update \
     && apt-get upgrade --yes
## Copy objects built in the builder phase
COPY --from=builder /usr/local/bin/* /usr/bin/
COPY start /usr/local/bin/
## Install production libraries
RUN  chmod 0755 /usr/local/bin/start \
     && apt-get install --yes \
          libboost-system1.74.0 \
          libcurl4 \
          libzmq5 \
          tzdata \
     && rm -rf /var/lib/apt/lists/*

EXPOSE 9001-9016
EXPOSE 9201
EXPOSE 12720-12722
ENTRYPOINT ["start"]
LABEL org.opencontainers.image.vendor="Open Digital Radio" 
LABEL org.opencontainers.image.description="DAB/DAB+ Multiplexer" 
LABEL org.opencontainers.image.authors="robin.alexander@netplus.ch" 
