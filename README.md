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
$ cd 2.6.3/pg12
$ docker-compose up
```

### Without compose

Run postgres database:
```
$ docker run --name pgrouting -p 5432:5432 pgrouting/pgrouting:v2.6.3-postgresql_12
```

### Using psql with Docker compose:

Example:

```
$ docker-compose exec postgis psql -h localhost -U postgres
psql (12.0)
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
 PostgreSQL 12.0 (Debian 12.0-1.pgdg100+1) on x86_64-pc-linux-gnu, compiled by gcc (Debian 8.3.0-6) 8.3.0, 64-bit
(1 row)

postgres@localhost test>select pgr_version();
                pgr_version                
-------------------------------------------
(2.6.3,v2.6.3,b14f4d56b,master,1.67.0)
(1 row)

postgres@localhost test>select postgis_full_version();
                                                                                                    postgis_full_version                                                                      

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------
POSTGIS="3.0.0 r17983" [EXTENSION] PGSQL="120" GEOS="3.7.1-CAPI-1.11.1 27a5e771" PROJ="Rel. 5.2.0, September 15th, 2018" LIBXML="2.9.4" LIBJSON="0.12.1" LIBPROTOBUF="1.3.1" WAGYU="0.4.3 (In
ternal)"
(1 row)
```

## License

This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.

## Links

- pgRouting Docker hub: https://hub.docker.com/r/pgrouting/pgrouting/
- pgRouting project: https://pgrouting.org/
- pgRouting github: https://github.com/pgRouting
