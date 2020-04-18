
FROM alpine:edge


ARG LIBSRTP_VERSION="v2.3.0"
ARG LIBWEBSOCKETS_VERSION="v3.2.2"
ARG USRSCTP_VERSION="0.9.3.0"
# USRSCTP_VERSION is not used due to:
# 1. https://github.com/sctplab/usrsctp/issues/325
# 2. https://github.com/sctplab/usrsctp/pull/417

# Install Build Dependencies
RUN apk update \
&& apk add --no-cache --virtual .build-deps \
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
  file \
  libmicrohttpd-dev \
  jansson-dev \
  openssl \
  openssl-dev \
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
# Install libsrtp (Secure Real-time Transport Protocol)
  && cd / \
  && git clone https://github.com/cisco/libsrtp.git \
  && cd libsrtp \
  && git checkout ${LIBSRTP_VERSION} \
  && ./configure --prefix=/usr --enable-openssl \
  && make shared_library \
  && make install \
# Install libwebsockets
  && cd / \
  && git clone https://github.com/warmcat/libwebsockets.git \
  && cd libwebsockets \
  && git checkout ${LIBWEBSOCKETS_VERSION} \
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
  && sh autogen.sh \
  && ./configure --prefix=/opt/janus --disable-rabbitmq --disable-mqtt \
  && make CFLAGS='-std=c99' \
  && make install \
  && make configs \
# Cleanup
  && rm -rf /libsrtp \
  && rm -rf /usrsctp \
  && rm -rf /libwebsockets \
  && rm -rf /janus-gateway \
  && apk del .build-deps \
  && rm -rf /var/cache/apk/* \
  && rm -rf /tmp/* \
  && apk update


CMD /opt/janus/bin/janus
