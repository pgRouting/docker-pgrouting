FROM pgrouting/pgrouting:11-3.3-develop

ENV OSM2PGROUTING_VERSION 2.3.8

RUN apt update \
 && apt install -y \
        libpqxx-6.4 \
 && apt install -y \
        build-essential \
        cmake \
        wget \
        libboost-program-options-dev \
        libexpat1 \
        libexpat-dev \
        libosmium2-dev \
        libpqxx-dev \
        zlib1g-dev \
 && cd /usr/local/src \
 && wget https://github.com/pgRouting/osm2pgrouting/archive/v${OSM2PGROUTING_VERSION}.tar.gz \
 && tar xvf v${OSM2PGROUTING_VERSION}.tar.gz \
 && cd osm2pgrouting-${OSM2PGROUTING_VERSION} \
 && mkdir build \
 && cd build \
 && cmake .. \
 && make \
 && make install \
 && cd ../tools/osmium/ \
 && mkdir build \
 && cd build \
 && cmake .. \
 && make \
 && make install \
 && cd /usr/local/src \
 && rm -rf ./* \
 && apt purge -y --autoremove \
        build-essential \
        cmake \
        wget \
        libboost-program-options-dev \
        libexpat-dev \
        libosmium2-dev \
        libpqxx-dev \
        zlib1g-dev \
 && apt autoremove -y \
 && rm -rf /var/lib/apt/lists/*
