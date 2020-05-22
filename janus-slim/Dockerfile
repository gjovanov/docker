FROM debian:buster-slim


ARG BUILD_DEPS=" \
  git \
  cmake \
  automake \
  libtool \
  build-essential \
  libcollection-dev \
  gengetopt"

ARG JANUS_DEPS=" \
  libmicrohttpd-dev \
  libjansson-dev \
  libssl-dev \
  libsofia-sip-ua-dev \
  libglib2.0-dev \
  libopus-dev \
  libogg-dev \
  libini-config-dev \
  libconfig-dev \
  libgnutls28-dev \
  gtk-doc-tools \
  pkg-config \
  libcurl4 \
  curl"

ARG LIBNICE_VERSION="0.1.16"
ARG LIBSRTP_VERSION="v2.3.0"
ARG LIBWEBSOCKETS_VERSION="v3.2.2"
ARG USRSCTP_VERSION="0.9.3.0"
ARG JANUS_VERSION="v0.9.5"
ARG DEBIAN_FRONTEND=noninteractive


RUN rm -rf /var/lib/apt/lists/* \
#sed -i 's/archive.ubuntu.com/mirror.aarnet.edu.au\/pub\/ubuntu\/archive/g' /etc/apt/sources.list \
  && export DEBIAN_FRONTEND=noninteractive \
  && apt-get update -y \
  && apt-get install -y --no-install-recommends apt-utils \
# Install Build Dependencies
  && apt-get install -y ${BUILD_DEPS} \
# Install Janus Dependencies
  && apt-get install -y ${JANUS_DEPS} \
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
# Clean up
  && cd / \
  && rm -rf /libnice \
  && rm -rf /libsrtp \
  && rm -rf /usrsctp \
  && rm -rf /libwebsockets \
  && rm -rf /janus-gateway \
  && apt-get remove -y ${BUILD_DEPS} \
  && apt-get autoremove -y \
  && apt-get install -y libconfig9 libglib2.0-0 \
  && apt-get clean -y \
  && apt-get autoremove --purge shared-mime-info -y \
  && rm -rf /var/lib/apt/* /tmp/* /var/tmp/*

CMD /opt/janus/bin/janus
