FROM ubuntu:bionic


# Environment
ENV PG_VERSION 11.1
ENV GEOS_VERSION 3.7.0
ENV PROJ4_VERSION 5.2.0
ENV GDAL_VERSION 2.3.2
ENV POSTGIS_VERSION 2.5.0
ENV GOSU_VERSION 1.9
ENV ENCODING UTF-8
ENV LOCALE en_US
ENV TERM xterm
ENV POSTGRES_PASSWD postgres
ENV PG_HBA "local all all trust#host all all 127.0.0.1/32 trust#host all all 0.0.0.0/0 md5#host all all ::1/128 trust"
ENV PG_CONF "max_connections=100#listen_addresses='*'#shared_buffers=128MB#dynamic_shared_memory_type=posix#log_timezone='UTC'#datestyle='iso, mdy'#timezone='UTC'#log_statement='all'#log_directory='pg_log'#log_filename='postgresql-%Y-%m-%d_%H%M%S.log'#logging_collector=on#client_min_messages=notice#log_min_messages=notice#log_line_prefix='%a %u %d %r %h %m %i %e'#log_destination='stderr'#log_rotation_size=500MB#log_error_verbosity=default"


# Load assets
WORKDIR /usr/local
ADD resources/run.sh /usr/local/bin/
ADD resources/compile.sh /usr/local/src/
ADD resources/pg_hba_conf /usr/local/bin
ADD resources/postgresql_conf /usr/local/bin
ADD resources/psqlrc /root/.psqlrc
ADD https://ftp.postgresql.org/pub/source/v${PG_VERSION}/postgresql-${PG_VERSION}.tar.bz2 /usr/local/src/
ADD http://download.osgeo.org/geos/geos-${GEOS_VERSION}.tar.bz2 /usr/local/src/
ADD http://download.osgeo.org/proj/proj-${PROJ4_VERSION}.tar.gz /usr/local/src/
ADD http://download.osgeo.org/gdal/${GDAL_VERSION}/gdal-${GDAL_VERSION}.tar.gz /usr/local/src/
ADD http://download.osgeo.org/postgis/source/postgis-${POSTGIS_VERSION}.tar.gz /usr/local/src/

# Install national language (locale) data
RUN apt-get update && apt-get install locales

# Compilation
RUN chmod 777 src/compile.sh
RUN src/compile.sh

# Port
EXPOSE 5432

# Volumes
VOLUME /data

STOPSIGNAL SIGINT
ENTRYPOINT ["/usr/local/bin/run.sh"]

CMD ["run_default"]
