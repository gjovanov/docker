
FROM alpine:edge

# Install Build Dependencies
RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/main openssl && \
  apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing gdal-dev && \
  apk add --no-cache \
  coreutils \
  doxygen \
  libmicrohttpd-dev \
  libressl-dev \
  jansson-dev \
  openssl-dev \
  libsrtp-dev \
  libcurl \
  glib-dev \
  opus-dev \
  libogg-dev \
  libconfig-dev \
  pkgconf \
  gengetopt \
  libtool autoconf \
  automake \
  cmake \
  libnice-dev \
  lksctp-tools-dev \
  git \
  gcc \
  make \
  g++ \
  zlib-dev


# Install usrsctp
RUN cd / \
  && git clone https://github.com/sctplab/usrsctp \
  && cd usrsctp \
  && git checkout origin/master \
  && git reset --hard 1c9c82fbe3582ed7c474ba4326e5929d12584005 \
  && ./bootstrap \
  && ./configure --prefix=/usr --disable-warnings-as-errors \
  && make \
  && make install

# Install libwebsockets
RUN cd / \
  && git clone https://github.com/warmcat/libwebsockets.git \
  && cd libwebsockets \
  && git checkout v3.2.2 \
  && mkdir build \
  && cd build \
  && cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr -DCMAKE_C_FLAGS="-fpic" -DLWS_MAX_SMP=1 -DLWS_IPV6="ON" .. \
  && make \
  && make install

# Install Janua Gateway
RUN cd / \
  && git clone https://github.com/meetecho/janus-gateway.git \
  && cd janus-gateway \
  && git checkout refs/tags/v0.9.1 \
  && sh autogen.sh \
  && ./configure --prefix=/opt/janus --disable-rabbitmq --disable-mqtt \
  && make \
  && make install \
  && make configs


CMD /opt/janus/bin/janus
