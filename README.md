# opendigitalradio/docker-dabmux

## Introduction
This repository is part of a project aiming at containerizing the [mmbTools](https://www.opendigitalradio.org/mmbtools) software stack of [Open Digital Radio](https://www.opendigitalradio.org/).

This repository fetures the [dab multiplexer](https://github.com/opendigitalradio/ODR-DabMux) component. 

## Setup
In order to allow for data persistence and data sharing among the various mmbTools containers, please follow these instructions:
1. Create a temporary `odr-data` directory structure on your host:
    ```
    mkdir --parents \
        ${HOME}/odr-data/mot \
        ${HOME}/odr-data/supervisor
    ```
1. Declare your time zone:
    ```
    TZ=your_time_zone (ex: Europe/Zurich)
    ```
1. Declare your mux configuration file:
    ```
    # case-1: you have a config file
    DABMUX_CONFIG=full_path_to_your_dabmux_configuration_file

    # case-2: you dont't have a config file. Take the sample from this repository
    DABMUX_CONFIG=./odr-data/odr-dabmux.info
    ```
1. Copy the mux configuration file into the temporary `odr-data` directory:
    ```
    cp ${DABMUX_CONFIG} ${HOME}/odr-data/
    ```
1. Create a docker network:
    ```
    docker network create odr
    ```

## Run
1. Create the container that will be started later. Please note that the image uses ports:
    - 9001 - 9016: incoming audio/PAD streams
    - 9201: output stream
    - 12720: multiplexer server management port
    - 12721: multiplexer ftp port
    - 12722: multiplexer ZMQ RC port

    ```
    docker container create \
        --name odr-dabmux \
        --env "TZ=${TZ}" \
        --volume odr-data:/odr-data \
        --network odr \
        --publish 9201:9201 \
        --publish 12720:12720 \
        --publish 12721:12721 \
        --publish 12722:12722 \
        opendigitalradio/dabmux:latest \
        /odr-data/$(basename ${DABMUX_CONFIG})
    ```
1. Copy the temporary `odr-data` directory to the container:
    ```
    docker container cp ${HOME}/odr-data odr-dabmux:/
    ```
1. Start the container 
    ```
    docker container start odr-dabmux
    ```

## Test
You can verify the dab multiplex output stream by following these steps:
1. Ensure you installed wget and dablin packages on your host:
1. Run the following command on your host: 
    ```
    wget -q -O - localhost:9201 | dablin_gtk -f edi -I -1
    ```
