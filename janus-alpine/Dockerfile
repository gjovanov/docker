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
  libwebsockets-dev \
  git \
  gcc \
  make \
  g++ \
  zlib-dev


# Install usrsctp
RUN git clone https://github.com/sctplab/usrsctp \
  && cd usrsctp \
  && git checkout origin/master \
  && git reset --hard 1c9c82fbe3582ed7c474ba4326e5929d12584005 \
  && ./bootstrap \
  && ./configure --prefix=/usr --disable-warnings-as-errors \
  && make && make install

# Install Janua Gateway
RUN git clone https://github.com/meetecho/janus-gateway.git \
  && cd janus-gateway \
  && sh autogen.sh \
  && ./configure --prefix=/opt/janus --disable-rabbitmq --disable-mqtt \
  && make CFLAGS='-std=c99' \
  && make install \
  && make configs


CMD /opt/janus/bin/janus
