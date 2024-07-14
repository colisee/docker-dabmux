FROM   debian:bookworm-backports
ENV    DEBIAN_FRONTEND=noninteractive
COPY   start /usr/local/bin/
RUN    chmod 0755 /usr/local/bin/start \
       && apt-get update \
       && apt-get upgrade --yes \
       && apt-get install --yes odr-dabmux \
       && rm -rf /var/lib/apt/lists/*

EXPOSE 9001-9016
EXPOSE 9201
EXPOSE 12720-12722
ENTRYPOINT ["start"]
LABEL org.opencontainers.image.vendor="Open Digital Radio" 
LABEL org.opencontainers.image.description="DAB/DAB+ Multiplexer" 
LABEL org.opencontainers.image.authors="robin.alexander@netplus.ch" 
