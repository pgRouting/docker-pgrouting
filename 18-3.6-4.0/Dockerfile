FROM postgis/postgis:18-3.6

LABEL maintainer="pgRouting Project - https://pgrouting.org"

ENV PGROUTING_VERSION=4.0.2
ENV PGROUTING_SHA256=2faf31b178db969637c1f392ba3ba18fba8d5aed15bdc73fbb4a53a72c5d0f71

RUN set -ex \
 && apt update \
 && apt install -y \
        libboost-atomic1.83.0 \
        libboost-chrono1.83.0 \
        libboost-graph1.83.0 \
        libboost-date-time1.83.0 \
        libboost-program-options1.83.0 \
        libboost-system1.83.0 \
        libboost-thread1.83.0 \
 && apt install -y \
        build-essential \
        cmake \
        wget \
        libboost-graph-dev \
        libpq-dev \
        postgresql-server-dev-${PG_MAJOR} \
 && wget -O pgrouting.tar.gz "https://github.com/pgRouting/pgrouting/archive/v${PGROUTING_VERSION}.tar.gz" \
 && echo "$PGROUTING_SHA256 *pgrouting.tar.gz" | sha256sum -c - \
 && mkdir -p /usr/src/pgrouting \
 && tar \
        --extract \
        --file pgrouting.tar.gz \
        --directory /usr/src/pgrouting \
        --strip-components 1 \
 && rm pgrouting.tar.gz \
 && cd /usr/src/pgrouting \
 && mkdir build \
 && cd build \
 && cmake .. \
 && make \
 && make install \
 && cd / \
 && rm -rf /usr/src/pgrouting \
 && apt-mark manual postgresql-18 \
 && apt purge -y --autoremove \
        build-essential \
        cmake \
        wget \
        libpq-dev \
        libboost-graph-dev \
        postgresql-server-dev-${PG_MAJOR} \
 && rm -rf /var/lib/apt/lists/*
RUN rm /docker-entrypoint-initdb.d/10_postgis.sh
