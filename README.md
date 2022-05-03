[![docker-publish](https://github.com/Opendigitalradio/docker-dabmux/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/Opendigitalradio/docker-dabmux/actions/workflows/docker-publish.yml)

# opendigitalradio/docker-dabmux

## Introduction
This repository is part of a project aiming at containerizing the [mmbTools](https://www.opendigitalradio.org/mmbtools) software stack of [Open Digital Radio](https://www.opendigitalradio.org/).

This repository features the [dab multiplexer (v4.2.1)](https://github.com/opendigitalradio/ODR-DabMux) component. 

## Quick setup
1. Get this repository on your host
1. Declare your time zone:
    ```
    TZ=your_time_zone (ex: TZ=Europe/Zurich)
    ```
1. Declare your mux configuration file:
    ```
    MUX_CONFIG=$(pwd)/config/odr-dabmux.info
    ```
1. Run the container. Please note that the image uses ports:
    - 9001 - 9016: incoming audio/PAD streams
    - 9201: output stream
    - 12720: multiplexer server management port
    - 12721: multiplexer ftp port
    - 12722: multiplexer ZMQ RC port

    ```
    docker container run \
        --name odr-dabmux \
        --detach \
        --rm \
        --env "TZ=${TZ}" \
        --network odr \
        --publish 9201:9201 \
        --publish 12720:12720 \
        --publish 12721:12721 \
        --publish 12722:12722 \
        --volume ${MUX_CONFIG}:/config/mux.ini \
        opendigitalradio/dabmux:latest \
        /config/mux.ini
    ```

## Test
You can verify the dab multiplex output stream by following these steps:
1. Ensure you installed wget and dablin packages on your host:
1. Run the following command on your host: 
    ```
    wget -q -O - localhost:9201 | dablin_gtk -f edi -I -1
    ```
