FROM debian:buster-slim AS prebuilder

ARG coturn_ver=4.5.1.3
ARG DEBIAN_FRONTEND=noninteractive


ADD scripts/ /scripts/

# Prebuilder is just for sake of caching and legibility. It is used to build Janus' dependancies Install Build Dependencies
RUN rm -rf /var/lib/apt/lists/* \
  && apt-get -y update \
  && apt-get install -yq apt-utils \
  && apt-get install -yq \
  libevent-dev \
  libcrypto1.1-udeb \
  libssl1.1 \
  libpq-dev \
  libmariadb3 \
  libmariadb-dev \
  libsqlite3-dev \
  libhiredis-dev \
  libmongoc-1.0-0 \
  libbson-1.0-0 \
  libtool \
  automake \
  autotools-dev \
  build-essential \
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
 && ./configure --prefix=/opt \
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

#FROM debian:buster-slim AS prebuilder
FROM debian@sha256:1b8a66f829a3563f98f941f4e0e2ecc619ad12f22331d297d2a9d1e2f18dc257
LABEL maintainer="Goran Jovanov <goran.jovanov@gmail.com>"
LABEL description="Janus Gateway Lean Docker Image"

# COPY VERSION .

ARG JANUS_VERSION="v0.10.8"
WORKDIR /opt/

COPY --from=prebuilder /opt .

ARG DEBIAN_FRONTEND=noninteractive

# Install Build Dependencies
RUN rm -rf /var/lib/apt/lists/* \
  && apt-get -y update \
  && apt-get autoremove -y \
  && apt-get install -y libconfig9 libglib2.0-0 \
  && apt-get clean \
  && apt-get autoremove --purge shared-mime-info -y \
  && rm -rf /var/lib/apt/*

EXPOSE 3478 3478/udp

RUN /scripts/detect_external_ip.sh

ENTRYPOINT ["/scripts/docker_entrypoint.sh"]

CMD ["-n", "--log-file=stdout", "--external-ip=$(REAL_EXTERNAL_IP)"]
