
FROM alpine:edge

# Install Build Dependencies
RUN apk add --no-cache --virtual .build-deps \
  gengetopt \
  libtool \
  autoconf \
  automake \
  cmake \
  git \
  gcc \
  make \
  g++ \
# Install Janus Dependencies
&& apk add --no-cache \
  bash \
  coreutils \
  doxygen \
  libmicrohttpd-dev \
  libressl-dev \
  jansson-dev \
  openssl \
  openssl-dev \
  gdal-dev \
  libsrtp-dev \
  libcurl \
  glib-dev \
  opus-dev \
  libogg-dev \
  libconfig-dev \
  pkgconf \
  libnice-dev \
  lksctp-tools-dev \
  zlib-dev \
# Install libwebsockets
  && cd / \
  && git clone https://github.com/warmcat/libwebsockets.git \
  && cd libwebsockets \
  && git checkout v3.2.2 \
  && mkdir build \
  && cd build \
  && cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr -DCMAKE_C_FLAGS="-fpic" -DLWS_MAX_SMP=1 -DLWS_IPV6="ON" .. \
  && make \
  && make install \
# Install usrsctp (data channels)
  && cd / \
  && git clone https://github.com/sctplab/usrsctp \
  && cd usrsctp \
  && git checkout origin/master \
  && git reset --hard 1c9c82fbe3582ed7c474ba4326e5929d12584005 \
  && ./bootstrap \
  && ./configure --prefix=/usr --disable-warnings-as-errors \
  && make \
  && make install \
# Install Janus Gateway
  && cd / \
  && git clone https://github.com/meetecho/janus-gateway.git \
  && cd janus-gateway \
#  && git checkout refs/tags/v0.9.1 \
  && sh autogen.sh \
  && ./configure --prefix=/opt/janus --disable-rabbitmq --disable-mqtt \
  && make \
  && make install \
  && make configs \
# Cleanup
  && rm -rf /usrsctp \
  && rm -rf /libwebsockets \
  && rm -rf /janus-gateway \
  && apk del .build-deps


CMD /opt/janus/bin/janus
