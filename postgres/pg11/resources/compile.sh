# Compilation of PostgreSQL, GEOS, Proj4, GDAL, and PostGIS 2


# Update and apt-get basic packages
apt-get update \
    && apt-get install -y \
	       build-essential \
	       python \
	       python-dev \
	       libreadline6-dev \
	       zlib1g-dev \
	       libssl-dev \
	       libxml2-dev \
	       libxslt-dev \
	       curl \
	       libjson-c-dev \
         pkg-config \
         libprotobuf-c-dev \
         libprotobuf-c1 \
         libprotoc-dev \
         protobuf-compiler \
         protobuf-c-compiler \
         


# Grab gosu
gpg --keyserver pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4

curl -o /usr/local/bin/gosu \
     -SL "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-$(dpkg --print-architecture)" > \
     /dev/null 2>&1 \
    && curl -o /usr/local/bin/gosu.asc \
	    -SL "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-$(dpkg --print-architecture).asc" > \
	    /dev/null 2>&1 \
    && gpg --verify /usr/local/bin/gosu.asc > /dev/null 2>&1 \
    && rm /usr/local/bin/gosu.asc > /dev/null 2>&1 \
    && chmod +x /usr/local/bin/gosu > /dev/null 2>&1


# Untar
cd src ; tar -xjvf postgresql-${PG_VERSION}.tar.bz2 ; cd ..
cd src ; tar -xjvf geos-${GEOS_VERSION}.tar.bz2 ; cd ..
cd src ; tar -xvf proj-${PROJ4_VERSION}.tar.gz ; cd ..
cd src ; tar -xvf gdal-${GDAL_VERSION}.tar.gz ; cd ..
cd src ; tar -xvf postgis-${POSTGIS_VERSION}.tar.gz ; cd ..


# Compilation of PostgreSQL
cd src/postgresql-${PG_VERSION} ; \
./configure --prefix=/usr/local --with-pgport=5432 --with-python --with-openssl --with-libxml --with-libxslt --with-zlib ; \
cd ../..

cd src/postgresql-${PG_VERSION} ; make ; cd ../..

cd src/postgresql-${PG_VERSION} ; make install ; cd ../..

cd src/postgresql-${PG_VERSION}/contrib ; make all ; cd ../../..

cd src/postgresql-${PG_VERSION}/contrib ; make install ; cd ../../..

ldconfig



# Compilation of GEOS
cd src/geos-${GEOS_VERSION} ; ./configure ; cd ../..

cd src/geos-${GEOS_VERSION} ; make ; cd ../..

cd src/geos-${GEOS_VERSION} ; make install ; cd ../..

ldconfig


# Compilation of Proj 4
cd src/proj-${PROJ4_VERSION} ; ./configure ; cd ../..

cd src/proj-${PROJ4_VERSION} ; make ; cd ../..

cd src/proj-${PROJ4_VERSION} ; make install ; cd ../..

ldconfig


# Compilation of GDAL
cd src/gdal-${GDAL_VERSION} ; ./configure ; cd ../..

cd src/gdal-${GDAL_VERSION} ; make ; cd ../..

cd src/gdal-${GDAL_VERSION} ; make install ; cd ../..

ldconfig


# Compilation of PostGIS
mv src/spatial_ref_sys.sql src/postgis-${POSTGIS_VERSION}/

cd src/postgis-${POSTGIS_VERSION} ; ./configure --with-topology --with-raster --with-jsondir=/usr/include/json-c ; cd ../..

cd src/postgis-${POSTGIS_VERSION} ; make ; cd ../..

cd src/postgis-${POSTGIS_VERSION} ; make install ; cd ../..

ldconfig


# Creation of postgres user and group
useradd --shell /bin/bash --home /data/ postgres


# Creation of data folder
mkdir -p /data/
chmod 0700 /data/
chown postgres:postgres /data/


# Clean up
rm -Rf /usr/local/src

chmod 755 /usr/local/bin/run.sh

chmod 777 /usr/local/bin/pg_hba_conf

chmod 777 /usr/local/bin/postgresql_conf

chmod 755 /usr/local/bin/gosu
