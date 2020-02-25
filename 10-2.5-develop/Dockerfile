FROM postgis/postgis:10-2.5

LABEL maintainer="pgRouting Project - https://pgrouting.net"

ENV PGROUTING_VERSION develop

RUN apt update \
 && apt install -y \
        libboost-atomic1.62.0 \
        libboost-chrono1.62.0 \
        libboost-graph1.62.0 \
        libboost-date-time1.62.0 \
        libboost-program-options1.62.0 \
        libboost-system1.62.0 \
        libboost-thread1.62.0 \
        libcgal12 \
 && apt install -y \
        build-essential \
        cmake \
        wget \
        libboost-graph-dev \
        libcgal-dev \
        libpq-dev \
        postgresql-server-dev-${PG_MAJOR} \
 && wget -O pgrouting.tar.gz "https://github.com/pgRouting/pgrouting/archive/${PGROUTING_VERSION}.tar.gz" \
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
 && apt purge -y --autoremove \
        build-essential \
        cmake \
        wget \
        libcgal-dev \
        libpq-dev \
        libboost-graph-dev \
        postgresql-server-dev-${PG_MAJOR} \
 && rm -rf /var/lib/apt/lists/*
RUN rm /docker-entrypoint-initdb.d/postgis.sh