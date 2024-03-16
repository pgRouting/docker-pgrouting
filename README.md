# docker-pgrouting

![Docker automated](https://img.shields.io/docker/cloud/automated/pgrouting/pgrouting)
![Docker status](https://img.shields.io/docker/cloud/build/pgrouting/pgrouting)
![Docker builds](https://img.shields.io/docker/pulls/pgrouting/pgrouting)


pgRouting Docker images.

**Note**: The outdated docker images folders for the unsupported pgRouting versions are removed, but they can be retrieved from the Git history, if needed by someone.

## Contents
- [Contents](#contents)
- [Versions](#versions)
- [Tag roles](#tag-roles)
- [How to use](#how-to-use)
- [How to build images](#how-to-build-images)
- [Develop](#develop)
- [License](#license)
- [Links](#links)

## Versions

There are several versions available:

- With pgRouting v3:
  - [3.6 with Postgres 16 + PostGIS 3.4](16-3.4-3.6/). Docker image: `pgrouting/pgrouting:16-3.4-3.6`
  - [3.5 with Postgres 16 + PostGIS 3.4](16-3.4-3.5/). Docker image: `pgrouting/pgrouting:16-3.4-3.5`
  - [3.4 with Postgres 15 + PostGIS 3.3](15-3.3-3.4/). Docker image: `pgrouting/pgrouting:15-3.3-3.4`
  - [3.4 with Postgres 14 + PostGIS 3.3](14-3.3-3.4/). Docker image: `pgrouting/pgrouting:14-3.3-3.4`
  - [3.4 with Postgres 13 + PostGIS 3.3](13-3.3-3.4/). Docker image: `pgrouting/pgrouting:13-3.3-3.4`
  - [3.4 with Postgres 12 + PostGIS 3.3](12-3.3-3.4/). Docker image: `pgrouting/pgrouting:12-3.3-3.4`
  - [3.4 with Postgres 11 + PostGIS 3.3](11-3.3-3.4/). Docker image: `pgrouting/pgrouting:11-3.3-3.4`
  - [3.3 with Postgres 15 + PostGIS 3.3](15-3.3-3.3/). Docker image: `pgrouting/pgrouting:15-3.3-3.3`
  - [3.3 with Postgres 14 + PostGIS 3.3](14-3.3-3.3/). Docker image: `pgrouting/pgrouting:14-3.3-3.3`
  - [3.3 with Postgres 13 + PostGIS 3.3](13-3.3-3.3/). Docker image: `pgrouting/pgrouting:13-3.3-3.3`
  - [3.3 with Postgres 12 + PostGIS 3.3](12-3.3-3.3/). Docker image: `pgrouting/pgrouting:12-3.3-3.3`
  - [3.3 with Postgres 11 + PostGIS 3.3](11-3.3-3.3/). Docker image: `pgrouting/pgrouting:11-3.3-3.3`
- With pgRouting main branch (*):
  - [main branch with Postgres 15 + PostGIS 3.3](15-3.3-main/). Docker image: `pgrouting/pgrouting:15-3.3-main`
  - [main branch with Postgres 14 + PostGIS 3.3](14-3.3-main/). Docker image: `pgrouting/pgrouting:14-3.3-main`
  - [main branch with Postgres 13 + PostGIS 3.3](13-3.3-main/). Docker image: `pgrouting/pgrouting:13-3.3-main`
  - [main branch with Postgres 12 + PostGIS 3.3](12-3.3-main/). Docker image: `pgrouting/pgrouting:12-3.3-main`
  - [main branch with Postgres 11 + PostGIS 3.3](11-3.3-main/). Docker image: `pgrouting/pgrouting:11-3.3-main`
- With pgRouting develop branch (*):
  - [develop branch with Postgres 15 + PostGIS 3.3](15-3.3-develop/). Docker image: `pgrouting/pgrouting:15-3.3-develop`
  - [develop branch with Postgres 14 + PostGIS 3.3](14-3.3-develop/). Docker image: `pgrouting/pgrouting:14-3.3-develop`
  - [develop branch with Postgres 13 + PostGIS 3.3](13-3.3-develop/). Docker image: `pgrouting/pgrouting:13-3.3-develop`
  - [develop branch with Postgres 12 + PostGIS 3.3](12-3.3-develop/). Docker image: `pgrouting/pgrouting:12-3.3-develop`
  - [develop branch with Postgres 11 + PostGIS 3.3](11-3.3-develop/). Docker image: `pgrouting/pgrouting:11-3.3-develop`

(*) If you want to use the last versions of develop or main branches you should consider to build the image by your own. See [here](#how-to-build-images) how to build images:

## Tag roles

`{PostgreSQL major}-{PostGIS major/minor}-{pgRouting version}`

Tag for pgRouting 3.4.1 with PostgreSQL 15 and PostGIS 3.3:

`pgrouting/pgrouting:15-3.3-3.4.1`

## How to use

### Running pgRouting with Docker compose

Run postgres database:
```sh
$ cd 15-3.3-3.4
$ docker-compose up
```

### Running pgRouting without Docker compose

Run postgres database:
```sh
$ cd 15-3.3-3.4
$ docker run --name pgrouting -e POSTGRES_PASSWORD=postgres -p 5432:5432 -d pgrouting/pgrouting:$(cat version.txt)
```

## How to build images

Building images:
```sh
$ cd 15-3.3-3.4
$ docker build -t pgrouting/pgrouting:$(cat version.txt) .
```

### Using psql with Docker compose:

```sh
$ docker-compose exec pgrouting psql -U postgres
```

Example:

```
psql (15.1 (Debian 15.1-1.pgdg110+1))
Type "help" for help.

postgres=# create database test;
CREATE DATABASE
postgres=# \c test
You are now connected to database "test" as user "postgres".
test=# create extension postgis;
CREATE EXTENSION
test=# create extension pgrouting;
CREATE EXTENSION
test=# select version();
                                                           version
-----------------------------------------------------------------------------------------------------------------------------
 PostgreSQL 15.1 (Debian 15.1-1.pgdg110+1) on x86_64-pc-linux-gnu, compiled by gcc (Debian 10.2.1-6) 10.2.1 20210110, 64-bit
(1 row)

test=# select pgr_version();
 pgr_version 
-------------
 3.4.1
(1 row)

test=# select postgis_full_version();
                                                                       postgis_full_version
---------------------------------------------------------------------------------------------------------------------------------------
----------------------------
 POSTGIS="3.3.2 4975da8" [EXTENSION] PGSQL="150" GEOS="3.9.0-CAPI-1.16.2" PROJ="7.2.1" LIBXML="2.9.10" LIBJSON="0.15" LIBPROTOBUF="1.3.
3" WAGYU="0.5.0 (Internal)"
(1 row)

test=# 
```

## Develop

To make new version for example `x.x`, run following:

```
mkdir 15-3.3-x.x
touch 15-3.3-x.x/Dockerfile
touch 15-3.3-x.x/version.txt
make update
```

`make update` run `update.sh`, that finds new Dockerfile and generates Dockerfile, docker-compose.yml, README.md, and extra/Dockerfile from template.

## License

This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.

## Links

- pgRouting Docker hub: https://hub.docker.com/r/pgrouting/pgrouting/
- pgRouting project: https://pgrouting.org/
- pgRouting github: https://github.com/pgRouting
