FROM pgrouting/postgres:pg10

# Environment
ENV PGROUTING_VERSION 2.6.1
ENV CGAL_VERSION 4.9
ENV OSM2PGR_VERSION 2.3.5

# Sources
ADD https://github.com/pgRouting/pgrouting/archive/v${PGROUTING_VERSION}.tar.gz $ROOTDIR/src/
ADD https://github.com/CGAL/cgal/archive/releases/CGAL-${CGAL_VERSION}.tar.gz $ROOTDIR/src/
ADD https://github.com/pgRouting/osm2pgrouting/archive/v${OSM2PGR_VERSION}.tar.gz $ROOTDIR/src/
ADD resources/compile.sh $ROOTDIR/src/

# Compilation
RUN chmod 777 $ROOTDIR/src/compile.sh
RUN $ROOTDIR/src/compile.sh
