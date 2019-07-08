FROM mdillon/postgis:10

# Environment
ENV PGROUTING_VERSION develop

RUN apt update \
 && apt install -y \
        build-essential \
        cmake \
        perl \
        wget \
        libboost-graph-dev \
        libpq-dev \
        postgresql-server-dev-${PG_MAJOR} \
 && cd /usr/local/src \
 && wget https://github.com/pgRouting/pgrouting/archive/${PGROUTING_VERSION}.tar.gz \
 && tar xvf ${PGROUTING_VERSION}.tar.gz \
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
        libpq-dev \
        postgresql-server-dev-${PG_MAJOR} \
 && apt install -y \
        postgresql-${PG_MAJOR}-postgis-${POSTGIS_MAJOR}-scripts \
        libboost-graph1.62.0 \
        libboost-program-options1.62.0 \
 && apt autoremove -y \
 && rm -rf /var/lib/apt/lists/*
