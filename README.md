[![docker-publish](https://github.com/Opendigitalradio/docker-dabmux/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/Opendigitalradio/docker-dabmux/actions/workflows/docker-publish.yml)

# opendigitalradio/docker-dabmux

## Introduction
This repository is part of a project aiming at containerizing the
[mmbTools](https://www.opendigitalradio.org/mmbtools) software stack of
[Open Digital Radio](https://www.opendigitalradio.org/).

This repository exposes the
[Opendigitalradio dab multiplexer](https://github.com/opendigitalradio/ODR-DabMux) inside a container.


## Pre-requisites
You need to install [docker](https://www.docker.com) or
[podman](https://podman.io) on your host to run the container image.
Please adapt the instructions below, according to your choice.

## How to get the container image on your host
You can either pull the container image from the internet or build it
yourself.

### Pull the image from internet
```
docker image pull opendigitalradio/dabmux
```

### Build the image
```
git clone \
  https://github.com/opendigitalradio/dabmux.git \
  docker-dabmux
cd docker-dabmux
docker image build \
  --tag opendigitalradio/dabmux \
  .
```

## Run the container
1. Set your time zone:
    ```
    TZ=Europe/Zurich
    ```
1. Set your mux configuration file:
    ```
    MUX_CONFIG=$(pwd)/example.mux
    ```
1. Run the container
   ```
   docker container run \
     --name odr-dabmux \
     --detach \
     --rm \
     --env "TZ=${TZ}" \
     --network host \
     --volume ${MUX_CONFIG}:/config/odr-dabmux.mux \
     opendigitalradio/dabmux
   ```

## Test
You can verify the dab multiplex output stream by following these steps:
1. Ensure you installed wget and dablin packages on your host:
1. Run the following command on your host: 
    ```
    wget -q -O - localhost:9201 | dablin_gtk -f edi -I -1
    ```
