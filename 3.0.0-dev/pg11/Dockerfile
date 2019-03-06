FROM pgrouting/postgres:pg11

# Environment
ENV PGROUTING_VERSION develop
ENV OSM2PGR_VERSION 2.3.6

# Sources
ADD https://github.com/pgRouting/pgrouting/archive/${PGROUTING_VERSION}.tar.gz $ROOTDIR/src/
ADD https://github.com/pgRouting/osm2pgrouting/archive/v${OSM2PGR_VERSION}.tar.gz $ROOTDIR/src/
ADD resources/compile.sh $ROOTDIR/src/

# Compilation
RUN chmod 777 $ROOTDIR/src/compile.sh
RUN $ROOTDIR/src/compile.sh
