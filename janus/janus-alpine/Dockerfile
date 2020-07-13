FROM alpine:edge

LABEL maintainer="Goran Jovanovs <goran.jovanov@gmail.com>"
LABEL description="Provides an Alpine image of Janus Gateway"


ARG LIBNICE_VERSION="0.1.16"
ARG LIBSRTP_VERSION="v2.3.0"
ARG LIBWEBSOCKETS_VERSION="v3.2.2"
ARG USRSCTP_VERSION="0.9.3.0"
ARG JANUS_VERSION="v0.10.3"
# USRSCTP_VERSION is not used due to:
# 1. https://github.com/sctplab/usrsctp/issues/325
# 2. https://github.com/sctplab/usrsctp/pull/417

# Install Build Dependencies
RUN apk update \
&& apk add --no-cache --virtual .build-deps \
  gtk-doc \
  util-linux-dev \
  gengetopt \
  libtool \
  autoconf \
  automake \
  cmake \
  file \
  git \
  gcc \
  make \
  g++ \
  --repository http://nl.alpinelinux.org/alpine/edge/testing \
  --repository http://nl.alpinelinux.org/alpine/edge/main \
# Install Janus Dependencies
&& apk add --no-cache \
  coreutils \
  libmicrohttpd-dev \
  jansson-dev \
  openssl \
  openssl-dev \
  libcurl \
  glib-dev \
  opus-dev \
  libogg-dev \
  libconfig-dev \
  pkgconf \
  lksctp-tools-dev \
  zlib-dev \
  --repository http://nl.alpinelinux.org/alpine/edge/testing \
  --repository http://nl.alpinelinux.org/alpine/edge/main \
#Install libnice
  && cd / \
  && git clone https://gitlab.freedesktop.org/libnice/libnice \
  && cd libnice \
  && git checkout ${LIBNICE_VERSION} \
  && ./autogen.sh \
  && ./configure --prefix=/usr \
  && make \
  && make install \
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
  && git checkout ${JANUS_VERSION} \
  && sh autogen.sh \
  && ./configure --prefix=/opt/janus --disable-rabbitmq --disable-mqtt \
  && make CFLAGS='-std=c99' \
  && make install \
  && make configs \
# Cleanup
  && rm -rf /libnice \
  && rm -rf /libsrtp \
  && rm -rf /usrsctp \
  && rm -rf /libwebsockets \
  && rm -rf /janus-gateway \
  && apk del .build-deps \
  && rm -rf /var/cache/apk/* \
  && rm -rf /tmp/* \
  && apk update


CMD /opt/janus/bin/janus
