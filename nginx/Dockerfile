FROM debian:buster-slim AS builder

LABEL maintainer="Goran Jovanov <goran.jovanov@gmail.com>"
LABEL x=y
ARG NGINX_PATH=/etc/nginx
ARG NGINX_VERSION=1.19.2
ARG MAXMIND_VERSION=1.4.2
ARG PCRE_VERSION=8.44
ARG ZLIB_VERSION=1.2.11


ARG DEBIAN_FRONTEND=noninteractive
ARG BUILD_DEPS="\
  build-essential \
  git \
  curl \
  cmake \
  wget \
  libpcre3 \
  libpcre3-dev \
  zlib1g-dev \
  zlib1g \
  golang-go"

WORKDIR /opt

RUN rm -rf /var/lib/apt/lists/* \
  && apt-get -y update \
  && apt-get install -yq apt-utils \
  && apt-get install -yq $BUILD_DEPS \
  && wget -qO- https://ftp.pcre.org/pub/pcre/pcre-${PCRE_VERSION}.tar.gz | tar zxvf - \
  && wget -qO- http://zlib.net/zlib-${ZLIB_VERSION}.tar.gz | tar zxvf - \
  && git clone --depth=1 --recursive https://github.com/leev/ngx_http_geoip2_module \
  && git clone --depth=1 --recursive https://github.com/cloudflare/quiche.git \
  && git clone --depth=1 --recursive https://github.com/google/ngx_brotli.git \
  && git clone --depth=1 --recursive https://github.com/openresty/headers-more-nginx-module.git \
  && git clone --depth=1 --recursive https://github.com/nginx/njs \
  && git clone --depth=1 --recursive https://github.com/AirisX/nginx_cookie_flag_module \
  && wget https://github.com/maxmind/libmaxminddb/releases/download/${MAXMIND_VERSION}/libmaxminddb-${MAXMIND_VERSION}.tar.gz \
  && tar xf libmaxminddb-${MAXMIND_VERSION}.tar.gz \
  && cd libmaxminddb-${MAXMIND_VERSION} \
  && ./configure \
  && make \
  && make check \
  && make install \
  && ldconfig \
  && cd .. \
  && curl -O https://nginx.org/download/nginx-$NGINX_VERSION.tar.gz \
  && tar xvzf nginx-$NGINX_VERSION.tar.gz \
  && cd nginx-$NGINX_VERSION \
  && patch -p01 < ../quiche/extras/nginx/nginx-1.16.patch \ 
  && curl https://sh.rustup.rs -sSf | sh -s -- -y -q \
  && export PATH="$HOME/.cargo/bin:$PATH" \
  && ./configure \
  --prefix=$NGINX_PATH \
  --sbin-path=/usr/sbin/nginx \
  --modules-path=/usr/lib/nginx/modules \
  --conf-path=$NGINX_PATH/nginx.conf \
  --error-log-path=/var/log/nginx/error.log \
  --http-log-path=/var/log/nginx/access.log \
  --pid-path=/var/run/nginx.pid \
  --lock-path=/var/run/nginx.lock \
  --http-client-body-temp-path=/var/cache/nginx/client_temp \
  --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
  --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
  --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
  --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
  --user=nginx \
  --group=nginx  \
  --with-pcre=/opt/pcre-${PCRE_VERSION} \
  --with-pcre-jit \
  --with-zlib=/opt/zlib-${ZLIB_VERSION} \
  --with-compat \
  --with-file-aio \
  --with-threads \
  --with-http_addition_module \
  --with-http_auth_request_module \
  --with-http_dav_module \
  --with-http_flv_module \
  --with-http_gunzip_module \
  --with-http_gzip_static_module \
  --with-http_mp4_module \
  --with-http_random_index_module \
  --with-http_realip_module \
  --with-http_secure_link_module \
  --with-http_slice_module \
  --with-http_ssl_module \
  --with-http_stub_status_module \
  --with-http_sub_module \
  --with-http_v2_module \
  --with-stream_realip_module \
  --with-mail \
  --with-mail_ssl_module \
  --with-stream \
  --with-stream_ssl_module \
  --with-stream_ssl_preread_module \
  --with-http_v3_module \
  --with-openssl=/opt/quiche/deps/boringssl \
  --with-quiche=/opt/quiche \
  --add-module=/opt/ngx_brotli \
  --add-module=/opt/ngx_http_geoip2_module \
  --add-module=/opt/headers-more-nginx-module \
  --add-module=/opt/njs/nginx \
  --add-module=/opt/nginx_cookie_flag_module \
  && make \
  && make install


FROM debian:buster-slim

COPY --from=builder /usr/sbin/nginx /usr/sbin/
COPY --from=builder /etc/nginx/ /etc/nginx/

ADD ./geoip/ /usr/share/geoip/

RUN rm -rf /var/lib/apt/lists/* \
  && groupadd  nginx \
  && useradd -m -d  /var/cache/nginx -s /sbin/nologin -g nginx nginx \
  # forward request and error logs to docker log collector
  && mkdir -p /var/log/nginx \
  && touch /var/log/nginx/access.log /var/log/nginx/error.log \
  && chown nginx: /var/log/nginx/access.log /var/log/nginx/error.log \
  && ln -sf /dev/stdout /var/log/nginx/access.log \
  && ln -sf /dev/stderr /var/log/nginx/error.log \
  && ls -al /usr/share/geoip/ \
  && cd / \
  && rm -Rf /tmp/* \
  && apt-get purge -y \
  && apt-get autoremove -y \
  && apt-get clean \
  && rm -rf /var/lib/apt/*


EXPOSE 80
EXPOSE 443

STOPSIGNAL SIGTERM

CMD ["nginx", "-g", "daemon off;"]


ARG VCS_REF

LABEL org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.vcs-ref=$VCS_REF \
  org.label-schema.vcs-url="https://github.com/gjovanov/docker.git"
