# docker-pgrouting

pgRouting Docker images.

## Contents
- [Contents](#contents)
- [Versions](#versions)
- [Tag roles](#tag-roles)
- [How to use](#how-to-use)
- [Develop](#develop)
- [License](#license)
- [Links](#links)

## Versions

There are several versions available:

- [2.6.1 with Postgres 10 + PostGIS 2.5](10-2.5-2.6.1/). Docker image: `pgrouting/pgrouting:10-2.5-2.6.1`
- [2.6.1 with Postgres 11 + PostGIS 2.5](11-2.5-2.6.1/). Docker image: `pgrouting/pgrouting:11-2.5-2.6.1`
- [2.6.2 with Postgres 10 + PostGIS 2.5](10-2.5-2.6.2/). Docker image: `pgrouting/pgrouting:10-2.5-2.6.2`
- [2.6.2 with Postgres 11 + PostGIS 2.5](11-2.5-2.6.2/). Docker image: `pgrouting/pgrouting:11-2.5-2.6.2`
- [2.6.3 with Postgres 10 + PostGIS 2.5](10-2.5-2.6.3/). Docker image: `pgrouting/pgrouting:10-2.5-2.6.3`
- [2.6.3 with Postgres 11 + PostGIS 2.5](11-2.5-2.6.3/). Docker image: `pgrouting/pgrouting:11-2.5-2.6.3`
- [2.6.3 with Postgres 12 + PostGIS 3.0](12-3.0-2.6.3/). Docker image: `pgrouting/pgrouting:12-3.0-2.6.3`
- [master branch with Postgres 10 + PostGIS 2.5](10-2.5-develop/). Docker image: `pgrouting/pgrouting:10-2.5-master`
- [master branch with Postgres 11 + PostGIS 2.5](11-2.5-develop/). Docker image: `pgrouting/pgrouting:11-2.5-master`
- [master branch with Postgres 12 + PostGIS 3.0](12-3.0-develop/). Docker image: `pgrouting/pgrouting:12-3.0-master`
- [develop branch with Postgres 10 + PostGIS 2.5](10-2.5-develop/). Docker image: `pgrouting/pgrouting:10-2.5-develop`
- [develop branch with Postgres 11 + PostGIS 2.5](11-2.5-develop/). Docker image: `pgrouting/pgrouting:11-2.5-develop`
- [develop branch with Postgres 12 + PostGIS 3.0](12-3.0-develop/). Docker image: `pgrouting/pgrouting:12-3.0-develop`

## Tag roles

`{PostgreSQL major}-{PostGIS major}-{pgRouting version}`

Tag for pgRouting 2.6.3 with PostgreSQL 12 and PostGIS 3.0:

`pgrouting/pgrouting:12-3.0-2.6.3`

## How to use

### Using with Docker compose

Run postgres database:
```
$ cd 12-3.0-2.6.3
$ docker-compose up
```

### Without compose

Run postgres database:
```
$ docker run --name pgrouting -p 5432:5432 pgrouting/pgrouting:12-3.0-2.6.3
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

## Develop

To make new version for example `x.x.x`, run following:

```
mkdir 12-3.0-x.x.x
touch 12-3.0-x.x.x/Dockerfile
make update
```

`make update` run `update.sh`, that finds new Dockerfile and generates Dockerfile, docker-compose.yml, README.md, and extra/Dockerfile from template.

## License

This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.

## Links

- pgRouting Docker hub: https://hub.docker.com/r/pgrouting/pgrouting/
- pgRouting project: https://pgrouting.org/
- pgRouting github: https://github.com/pgRouting
