FROM ubuntu:16.04

LABEL maintainer="Goran Jovanov <goran.jovanov@gmail.com>"

RUN apt-get update && \
    apt-get install -y \
        apt-utils \
	    sudo \
        procps \
        --no-install-recommends && \
    \
    # coTurn + mongo driver pre req
    apt-get install -y \
    	build-essential \
	    automake \
	    autoconf \
	    libtool \
	    libssl-dev \
	    libevent-dev \
        libyajl-dev	 \
        libcurl4-openssl-dev \
	    git && \
    \
    # install mongo-c-driver
    git clone https://github.com/mongodb/mongo-c-driver.git && \
    cd mongo-c-driver/ && \
    ./autogen.sh && \
    ./configure && \
    make && \
    make install && \
    \
    # install coturn
    cd / && \
    git clone https://github.com/coturn/coturn.git && \
    cd coturn/ && \
    ./configure && \
    make && \
    make install