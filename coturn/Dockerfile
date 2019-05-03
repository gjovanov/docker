FROM ubuntu:16.04

LABEL maintainer="Goran Jovanov <goran.jovanov@gmail.com>"

ADD scripts/ /scripts/

RUN	apt-get update && \
	apt-get install -y \
		apt-utils \
		sudo \
		procps \
		--no-install-recommends && \
# COTURN + mongo driver pre requisites
	apt-get install -y \
		build-essential \
		cmake \
		automake \
		autoconf \
		libtool \
		libssl-dev \
		libevent-dev \
		libyajl-dev	 \
		libcurl4-openssl-dev \
		git && \
	cd /tmp/ && \
# install mongo-c-driver
	git clone https://github.com/mongodb/mongo-c-driver.git && \
	cd mongo-c-driver/ && \
	cmake -DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_INSTALL_PREFIX=/usr \
		-DCMAKE_INSTALL_LIBDIR=lib \
		-DENABLE_BSON:STRING=ON \
		-DENABLE_MONGOC:BOOL=ON \
		-DENABLE_SSL:STRING=OPENSSL \
		-DENABLE_AUTOMATIC_INIT_AND_CLEANUP:BOOL=OFF \
		-DENABLE_MAN_PAGES:BOOL=OFF \
		-DENABLE_TESTS:BOOL=ON \
		-DENABLE_EXAMPLES:BOOL=OFF \
		-DCMAKE_SKIP_RPATH=ON \
		/tmp/mongo-c-driver && \
	make && \
		MONGOC_TEST_SKIP_MOCK=on \
		MONGOC_TEST_SKIP_SLOW=on \
		MONGOC_TEST_SKIP_LIVE=on \
		make check && \
	make install && \
# install coturn
	cd /tmp/ && \
	git clone https://github.com/coturn/coturn.git && \
	cd coturn/ && \
	./configure \
		--prefix=/usr \
		--turndbdir=/var/lib/coturn \
		--disable-rpath \
		--sysconfdir=/etc/coturn && \
	make && \
	make install && \
	make distclean && \
# cleanup
	apt-get remove -y \
		build-essential \
		cmake \
		automake \
		autoconf \
		libtool \
		libssl-dev \
		libyajl-dev \
		libcurl4-openssl-dev \
		git && \
	apt-get autoremove -y && \
	rm -rf /var/cache/apt/* /tmp/* \

RUN /scripts/detect_external_ip.sh


ENTRYPOINT ["/scripts/docker_entrypoint.sh"]

CMD ["-n", "--log-file=stdout", "--external-ip=$(/scripts/detect_external_ip.sh)"]
