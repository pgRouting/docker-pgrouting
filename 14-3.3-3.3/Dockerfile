FROM postgis/postgis:14-3.3

LABEL maintainer="pgRouting Project - https://pgrouting.net"

ENV PGROUTING_VERSION 3.3.5
ENV PGROUTING_SHA256 7a6c3ed612b6f803d8919a3fa66b8105cd48177ca0c872878e06c93c7b53537f

RUN set -ex \
 && apt update \
 && apt install -y \
        libboost-atomic1.74.0 \
        libboost-chrono1.74.0 \
        libboost-graph1.74.0 \
        libboost-date-time1.74.0 \
        libboost-program-options1.74.0 \
        libboost-system1.74.0 \
        libboost-thread1.74.0 \
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
 && apt-mark manual postgresql-14 \
 && apt purge -y --autoremove \
        build-essential \
        cmake \
        wget \
        libpq-dev \
        libboost-graph-dev \
        postgresql-server-dev-${PG_MAJOR} \
 && rm -rf /var/lib/apt/lists/*
RUN rm /docker-entrypoint-initdb.d/10_postgis.sh
