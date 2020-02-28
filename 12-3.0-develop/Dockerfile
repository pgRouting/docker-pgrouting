FROM postgis/postgis:12-3.0

LABEL maintainer="pgRouting Project - https://pgrouting.net"

ENV PGROUTING_VERSION develop
ENV PGROUTING_GIT_HASH d93c618ae9c2c57885c8a52287ae226ee7b9a4a4

RUN apt update \
 && apt install -y \
        libboost-atomic1.67.0 \
        libboost-chrono1.67.0 \
        libboost-graph1.67.0 \
        libboost-date-time1.67.0 \
        libboost-program-options1.67.0 \
        libboost-system1.67.0 \
        libboost-thread1.67.0 \
        libcgal13 \
 && apt install -y \
        build-essential \
        cmake \
        libboost-graph-dev \
        libcgal-dev \
        libpq-dev \
        postgresql-server-dev-${PG_MAJOR} \
        git \
 && mkdir -p /usr/src/pgrouting \
 && cd /usr/src/pgrouting \
 && git init \
 && git remote add origin https://github.com/pgRouting/pgrouting.git \
 && git fetch --depth 1 origin :${PGROUTING_GIT_HASH} \
 && git reset --hard FETCH_HEAD \
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
        libcgal-dev \
        libpq-dev \
        libboost-graph-dev \
        postgresql-server-dev-${PG_MAJOR} \
        git \
 && rm -rf /var/lib/apt/lists/*
RUN rm /docker-entrypoint-initdb.d/postgis.sh