# docker-pgrouting

[![Build Status](https://github.com/pgRouting/docker-pgrouting/actions/workflows/main.yml/badge.svg?branch=master)](https://github.com/pgRouting/docker-pgrouting/actions/workflows/main.yml?query=branch%3Amaster)
![Docker pulls](https://img.shields.io/docker/pulls/pgrouting/pgrouting)


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
  - [3.7 with Postgres 17 + PostGIS 3.5](17-3.5-3.7/). Docker image: `pgrouting/pgrouting:17-3.5-3.7`
  - [3.7 with Postgres 16 + PostGIS 3.5](16-3.5-3.7/). Docker image: `pgrouting/pgrouting:16-3.5-3.7`
  - [3.7 with Postgres 15 + PostGIS 3.5](15-3.5-3.7/). Docker image: `pgrouting/pgrouting:15-3.5-3.7`
  - [3.7 with Postgres 14 + PostGIS 3.5](14-3.5-3.7/). Docker image: `pgrouting/pgrouting:14-3.5-3.7`
  - [3.7 with Postgres 13 + PostGIS 3.5](13-3.5-3.7/). Docker image: `pgrouting/pgrouting:13-3.5-3.7`
  - [3.6 with Postgres 17 + PostGIS 3.5](17-3.5-3.6/). Docker image: `pgrouting/pgrouting:17-3.5-3.6`
  - [3.6 with Postgres 16 + PostGIS 3.5](16-3.5-3.6/). Docker image: `pgrouting/pgrouting:16-3.5-3.6`
  - [3.6 with Postgres 15 + PostGIS 3.5](15-3.5-3.6/). Docker image: `pgrouting/pgrouting:15-3.5-3.6`
  - [3.6 with Postgres 14 + PostGIS 3.5](14-3.5-3.6/). Docker image: `pgrouting/pgrouting:14-3.5-3.6`
  - [3.6 with Postgres 13 + PostGIS 3.5](13-3.5-3.6/). Docker image: `pgrouting/pgrouting:13-3.5-3.6`
- With pgRouting main branch (*):
  - [main branch with Postgres 17 + PostGIS 3.5](17-3.5-main/). Docker image: `pgrouting/pgrouting:17-3.5-main`
  - [main branch with Postgres 16 + PostGIS 3.5](16-3.5-main/). Docker image: `pgrouting/pgrouting:16-3.5-main`
  - [main branch with Postgres 15 + PostGIS 3.5](15-3.5-main/). Docker image: `pgrouting/pgrouting:15-3.5-main`
  - [main branch with Postgres 14 + PostGIS 3.5](14-3.5-main/). Docker image: `pgrouting/pgrouting:14-3.5-main`
  - [main branch with Postgres 13 + PostGIS 3.5](13-3.5-main/). Docker image: `pgrouting/pgrouting:13-3.5-main`
- With pgRouting develop branch (*):
  - [develop branch with Postgres 17 + PostGIS 3.5](17-3.5-develop/). Docker image: `pgrouting/pgrouting:17-3.5-develop`
  - [develop branch with Postgres 16 + PostGIS 3.5](16-3.5-develop/). Docker image: `pgrouting/pgrouting:16-3.5-develop`
  - [develop branch with Postgres 15 + PostGIS 3.5](15-3.5-develop/). Docker image: `pgrouting/pgrouting:15-3.5-develop`
  - [develop branch with Postgres 14 + PostGIS 3.5](14-3.5-develop/). Docker image: `pgrouting/pgrouting:14-3.5-develop`
  - [develop branch with Postgres 13 + PostGIS 3.5](13-3.5-develop/). Docker image: `pgrouting/pgrouting:13-3.5-develop`

(*) If you want to use the last versions of develop or main branches you should consider to build the image by your own. See [here](#how-to-build-images) how to build images:

## Tag roles

`{PostgreSQL major}-{PostGIS major/minor}-{pgRouting version}`

Tag for pgRouting 3.7.3 with PostgreSQL 17 and PostGIS 3.5:

`pgrouting/pgrouting:17-3.5-3.7.3`

## How to use

### Running pgRouting with Docker compose

Run postgres database:
```sh
$ cd 17-3.5-3.7
$ docker compose up
```

### Running pgRouting without Docker compose

Run postgres database:
```sh
$ cd 17-3.5-3.7
$ docker run --name pgrouting -e POSTGRES_PASSWORD=postgres -p 5432:5432 -d pgrouting/pgrouting:$(cat version.txt)
```

## How to build images

Building images:
```sh
$ cd 17-3.5-3.7
$ docker build -t pgrouting/pgrouting:$(cat version.txt) .
```

### Using psql with Docker compose:

```sh
$ docker compose exec pgrouting psql -U postgres
```

Example:

```
psql (17.2 (Debian 17.2-1.pgdg110+1))
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
 PostgreSQL 17.2 (Debian 17.2-1.pgdg110+1) on x86_64-pc-linux-gnu, compiled by gcc (Debian 10.2.1-6) 10.2.1 20210110, 64-bit
(1 row)

test=# select pgr_version();
 pgr_version 
-------------
 3.7.3
(1 row)

test=# select postgis_full_version();
                                  postgis_full_version                                                                                                                                                                    
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 POSTGIS="3.5.2 dea6d0a" [EXTENSION] PGSQL="170" GEOS="3.9.0-CAPI-1.16.2" PROJ="7.2.1 NETWORK_ENABLED=OFF URL_ENDPOINT=https://cdn.proj.org USER_WRITABLE_DIRECTORY=/var/lib/postgresql/.local/share/proj DATABASE_PATH=/usr/share/proj/proj.db" (compiled against PROJ 7.2.1) LIBXML="2.9.10" LIBJSON="0.15" LIBPROTOBUF="1.3.3" WAGYU="0.5.0 (Internal)"
(1 row)

test=# 
```

## Develop

To make new version for example `x.x`, run following:

```
mkdir 17-3.5-x.x
touch 17-3.5-x.x/Dockerfile
touch 17-3.5-x.x/version.txt
make update
```

`make update` run `update.sh`, that finds new Dockerfile and generates Dockerfile, docker-compose.yml, README.md, and extra/Dockerfile from template.

## License

This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.

## Links

- pgRouting Docker hub: https://hub.docker.com/r/pgrouting/pgrouting/
- pgRouting project: https://pgrouting.org/
- pgRouting github: https://github.com/pgRouting
