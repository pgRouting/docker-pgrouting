# docker-pgrouting

pgRouting Docker images.

## Contents
- [Versions](#versions)
- [How to use](#how-to-use)
- [License](#license)
- [Links](#links)

## Versions

There are several versions available:

- [2.6.1 with Postgres 10](2.6.1/pg10).
- [2.6.1 with Postgres 11](2.6.1/pg11).
- [2.6.2 with Postgres 10](2.6.2/pg10).
- [2.6.2 with Postgres 11](2.6.2/pg11).
- [2.6.3 with Postgres 10](2.6.3/pg10).
- [2.6.3 with Postgres 11](2.6.3/pg11).
- [2.6.3 with Postgres 12](2.6.3/pg12).
- [3.0.0.-dev with Postgres 10](3.0.0-dev/pg10).
- [3.0.0.-dev with Postgres 11](3.0.0-dev/pg11).
- [3.0.0.-dev with Postgres 12](3.0.0-dev/pg12).

## How to use

### Using with Docker compose

Run postgres database:
```
$ cd 3.0.0-dev/pg10
$ docker-compose up
```

### Without compose

Run postgres database:
```
$ docker run --name pgrouting -p 5432:5432 pgrouting/pgrouting:v2.6.3-postgresql_11
```

### Using psql with Docker compose:

Example:

```
$ docker-compose exec postgis psql -h localhost -U postgres
psql (11.1)
Type "help" for help.

postgres@localhost ~>create database test;
CREATE DATABASE

postgres@localhost ~>\c test
You are now connected to database "test" as user "postgres".
postgres@localhost test>create extension postgis;                                          
CREATE EXTENSION

postgres@localhost test>create extension pgrouting ;
CREATE EXTENSION

postgres@localhost test>select version();
                                               version                                                
------------------------------------------------------------------------------------------------------
 PostgreSQL 11.1 on x86_64-pc-linux-gnu, compiled by gcc (Ubuntu 7.3.0-27ubuntu1~18.04) 7.3.0, 64-bit
(1 row)

postgres@localhost test>select pgr_version();
                pgr_version                
-------------------------------------------
 (2.6.1,v2.6.1,1360698,release/2.6,1.65.1)
(1 row)

postgres@localhost test>select postgis_full_version();
                                                                                                    postgis_full_version                                                                      

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------
 POSTGIS="2.5.0 r16836" [EXTENSION] PGSQL="110" GEOS="3.7.0-CAPI-1.11.0 673b9939" PROJ="Rel. 5.2.0, September 15th, 2018" GDAL="GDAL 2.3.2, released 2018/09/21" LIBXML="2.9.4" LIBJSON="0.12.
1" LIBPROTOBUF="1.2.1" RASTER
(1 row)
```

## License

This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.

## Links

- pgRouting Docker hub: https://hub.docker.com/r/pgrouting/pgrouting/
- pgRouting project: https://pgrouting.org/
- pgRouting github: https://github.com/pgRouting
