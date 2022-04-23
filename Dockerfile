# Build odr-audioenc
FROM debian:bullseye-slim AS builder
ARG  DEBIAN_FRONTEND=noninteractive
RUN  apt-get update && \
     apt-get upgrade --yes && \
     apt-get install --yes \
          apt-utils
RUN  apt-get install --yes \
          automake \
          build-essential \
          curl \
          git \
          libtool \
          pkg-config
RUN  apt-get install --yes \
          libboost-system-dev \
          libcurl4-openssl-dev \
          libzmq3-dev  
ARG  URL=ODR-DabMux/archive/refs/tags/v4.2.1.tar.gz
RUN  cd /root && \
     curl -L https://github.com/Opendigitalradio/${URL} | tar -xz && \
     cd ODR* && \
     ./bootstrap.sh && \
     ./configure && \
     make && make install 

# Build the final image
FROM debian:bullseye-slim
ARG  DEBIAN_FRONTEND=noninteractive
## Update system
RUN  apt-get update && \
     apt-get upgrade --yes && \
     apt-get install --yes \
          apt-utils
## Install specific packages
RUN  apt-get install --yes \
          libboost-system1.74.0 \
          libcurl4 \
          libzmq5 && \
     rm -rf /var/lib/apt/lists/*
## Document image
LABEL org.opencontainers.image.vendor="Open Digital Radio" 
LABEL org.opencontainers.image.description="DAB/DAB+ Multiplexer" 
LABEL org.opencontainers.image.authors="robin.alexander@netplus.ch" 
## Copy objects built in the builder phase
COPY --from=builder /usr/local/bin/* /usr/bin/
COPY start /usr/local/bin/
## Customization
RUN  chmod 0755 /usr/local/bin/start
EXPOSE 9001-9016
EXPOSE 9201
EXPOSE 12720-12722
ENTRYPOINT ["start"]
