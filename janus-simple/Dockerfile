FROM buildpack-deps:stretch

LABEL maintainer="Goran Jovanovs <goran.jovanov@gmail.com>"
LABEL description="Provides an image with Janus Gateway"

RUN apt-get update -y \
    && apt-get upgrade -y

RUN apt-get -y update && apt-get install -y libmicrohttpd-dev \
    libjansson-dev \
    libssl-dev \
    libsrtp-dev \
    libsofia-sip-ua-dev \
    libglib2.0-dev \
    libopus-dev \
    libogg-dev \
    libini-config-dev \
    libcollection-dev \
    libconfig-dev \
    pkg-config \
    gengetopt \
    libtool \
    automake \
    build-essential \
    subversion \
    git \
    cmake \
    unzip \
    zip \
    lsof wget nano sudo


RUN apt-get install -y \
    sudo \
    make \
    git \
    doxygen \
    graphviz \
    cmake

RUN apt-get remove -y libsrtp-dev libsrtp0-dev \
    && cd ~ \
    && git clone https://github.com/cisco/libsrtp.git \
    && cd libsrtp \
    && git checkout v2.2.0 \
    && ./configure --prefix=/usr --enable-openssl \
    && make shared_library \
    && sudo make install


RUN cd ~ \
    && git clone https://github.com/sctplab/usrsctp.git \
    && cd usrsctp \
    && git checkout origin/master && git reset --hard 1c9c82fbe3582ed7c474ba4326e5929d12584005 \
    && ./bootstrap \
    && ./configure --prefix=/usr \
    && make \
    && sudo make install

RUN cd ~ \
    && git clone https://github.com/warmcat/libwebsockets.git \
    && cd libwebsockets \
    && git checkout v3.1.0 \
    && mkdir build \
    && cd build \
    && cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr -DCMAKE_C_FLAGS="-fpic" -DLWS_MAX_SMP=1 -DLWS_IPV6="ON" .. \
    && make \
    && sudo make install

RUN apt-get remove -y libnice-dev libnice10 \
    && echo "deb http://deb.debian.org/debian  stretch-backports main" >> /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -y gtk-doc-tools libgnutls28-dev -t stretch-backports \
    && git clone https://gitlab.freedesktop.org/libnice/libnice.git \
    && cd libnice \
    && git checkout 67807a17ce983a860804d7732aaf7d2fb56150ba \
    && bash autogen.sh \
    && ./configure --prefix=/usr \
    && make \
    && sudo make install

RUN cd ~ \
    && git clone https://github.com/meetecho/janus-gateway.git \
    && cd janus-gateway \
    && git checkout v0.9.1 \
    && sh autogen.sh \
    && ./configure --prefix=/opt/janus --disable-rabbitmq --disable-mqtt --enable-docs \
    && make CFLAGS='-std=c99' \
    && make install \
    && make configs

RUN cp -rp ~/janus-gateway/certs /opt/janus/share/janus

RUN apt-get install nginx -y
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80 7088 8088 8188 8089
EXPOSE 10000-11200/udp

CMD service nginx restart && /opt/janus/bin/janus --nat-1-1=${DOCKER_IP}
