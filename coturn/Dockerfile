FROM debian:buster-slim AS prebuilder

ARG coturn_ver=4.5.1.3
ARG DEBIAN_FRONTEND=noninteractive

# Prebuilder is just for sake of caching and legibility. It is used to build Janus' dependancies Install Build Dependencies
RUN rm -rf /var/lib/apt/lists/* \
  && apt-get -y update \
  && apt-get install -yq apt-utils \
  && apt-get install -yq \
  adduser \
  libevent-dev \
  libevent-core-2.1-6 \
  libevent-extra-2.1-6 \
  libevent-openssl-2.1-6 \
  libevent-pthreads-2.1-6  \
  libhiredis-dev \
  libhiredis0.14 \
  libmariadb3 \
  libmariadb-dev \
  libpq5 \
  libpq-dev \
  libsqlite3-0 \
  libsqlite3-dev \
  libssl1.1 \
  libssl-dev \
  lsb-base \
  sqlite3 \
  telnet \
#  sip-router \
#  xmpp-server \
  libmongoc-1.0-0 \
  libbson-1.0-0 \
  libtool \
  automake \
  autotools-dev \
  build-essential \
  curl \
  g++ \
  git \
  cmake \
  autoconf \
 # Download and prepare Coturn sources.
 && curl -fL -o /tmp/coturn.tar.gz \
         https://github.com/coturn/coturn/archive/${coturn_ver}.tar.gz \
 && tar -xzf /tmp/coturn.tar.gz -C /tmp/ \
 && cd /tmp/coturn-* \
# Build Coturn from sources.
 && ./configure \
        --prefix=/opt/coturn \
        --turndbdir=/var/lib/coturn \
        --disable-rpath \
        --sysconfdir=/etc/coturn \
        # No documentation included to keep image size smaller.
        --mandir=/tmp/coturn/man \
        --docsdir=/tmp/coturn/docs \
        --examplesdir=/tmp/coturn/examples \
 && make \
    \
 # Install and configure Coturn.
 && make install

FROM debian:buster-slim
#FROM debian@sha256:1b8a66f829a3563f98f941f4e0e2ecc619ad12f22331d297d2a9d1e2f18dc257
LABEL maintainer="Goran Jovanov <goran.jovanov@gmail.com>"
LABEL description="Coturn Docker Image"

# COPY VERSION .

ARG JANUS_VERSION="v0.10.8"
WORKDIR /opt/

COPY --from=prebuilder /opt .

ARG DEBIAN_FRONTEND=noninteractive

COPY scripts/ /scripts/

# Install Build Dependencies
RUN rm -rf /var/lib/apt/lists/* \
  && apt-get -y update \
  && apt-get autoremove -y \
  && apt-get install -y curl \
  && ls /opt/coturn \
#  && ls /opt/coturn\lib \
#  && apt-get install -y libconfig9 libglib2.0-0 \
  && apt-get clean \
  && apt-get autoremove --purge shared-mime-info -y \
  && rm -rf /var/lib/apt/*


#RUN chmod +x /scripts/docker-entrypoint.sh \
#             /scripts/detect-external-ip.sh \
# && ln -s /scripts/detect-external-ip.sh \
#          /scripts/detect-external-ip

EXPOSE 3478 3478/udp

RUN /scripts/detect_external_ip.sh

ENTRYPOINT ["/scripts/docker_entrypoint.sh"]

CMD ["-n", "--log-file=stdout", "--external-ip=$(REAL_EXTERNAL_IP)"]
