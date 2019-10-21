FROM postgres:12

ENV POSTGIS_MAJOR 3
ENV PGROUTING_VERSION 2.6.3

RUN apt update \
 && apt install -y \
        build-essential \
        cmake \
        perl \
        wget \
        libboost-graph-dev \
        libcgal-dev \
        libpq-dev \
        postgresql-${PG_MAJOR}-postgis-${POSTGIS_MAJOR} \
        postgresql-server-dev-${PG_MAJOR} \
 && cd /usr/local/src \
 && wget https://github.com/pgRouting/pgrouting/archive/v${PGROUTING_VERSION}.tar.gz \
 && tar xvf v${PGROUTING_VERSION}.tar.gz \
 && cd pgrouting-${PGROUTING_VERSION} \
 && mkdir build \
 && cd build \
 && cmake .. \
 && make \
 && make install \
 && cd ../../ \
 && rm -rf ./* \
 && apt purge -y \
        build-essential \
        cmake \
        perl \
        wget \
        libcgal-dev \
        libpq-dev \
        postgresql-server-dev-${PG_MAJOR} \
 && apt update \
 && apt install -y \
        postgresql-${PG_MAJOR}-postgis-${POSTGIS_MAJOR}-scripts \
        libboost-atomic1.67.0 \
        libboost-chrono1.67.0 \
        libboost-graph1.67.0 \
        libboost-date-time1.67.0 \
        libboost-program-options1.67.0 \
        libboost-system1.67.0 \
        libboost-thread1.67.0 \
        libcgal13 \
 && apt autoremove -y \
 && rm -rf /var/lib/apt/lists/*
