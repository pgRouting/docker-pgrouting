#!/bin/bash
# Derived from https://github.com/docker-library/postgres/blob/master/update.sh
set -Eeuo pipefail

cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"

versions=( "$@" )
if [ ${#versions[@]} -eq 0 ]; then
	versions=( */Dockerfile )
fi
versions=( "${versions[@]%/Dockerfile}" )

# sort version numbers with highest last (so it goes first in .travis.yml)
IFS=$'\n'; versions=( $(echo "${versions[*]}" | sort -V) ); unset IFS

defaultDebianSuite='buster-slim'
declare -A debianSuite=(
    # https://github.com/docker-library/postgres/issues/582
    [9.5]='stretch-slim'
    [9.6]='stretch-slim'
    [10]='stretch-slim'
    [11]='stretch-slim'
)

defaultPostgisDebPkgNameVersionSuffix='3'
declare -A postgisDebPkgNameVersionSuffixes=(
    [2.5]='2.5'
    [3.0]='3'
)

for version in "${versions[@]}"; do
    IFS=- read postgresVersion postgisVersion pgroutingVersion <<< "$version"

    tag="${debianSuite[$postgresVersion]:-$defaultDebianSuite}"
    suite="${tag%%-slim}"
    
    if [ "$suite" = "stretch" ]; then
      boostVersion="1.62.0"
      cdalVersion="12"
      pqxxVersion="4.0v5"
    else
      boostVersion="1.67.0"
      cdalVersion="13"
      pqxxVersion="6.2"
    fi

    srcVersion="${pgroutingVersion}"
    srcSha256="$(curl -sSL "https://github.com/pgRouting/pgrouting/archive/v${srcVersion}.tar.gz" | sha256sum | awk '{ print $1 }')"
    (
        set -x
        cp -p -r Dockerfile.template README.md.template docker-compose.yml.template extra "$version/"
        if [ "$pgroutingVersion" == "develop" ]; then
          cp -p Dockerfile.develop.template "$version/Dockerfile.template"
        fi
        mv "$version/Dockerfile.template" "$version/Dockerfile"
        sed -i 's/%%PG_MAJOR%%/'"$postgresVersion"'/g; s/%%POSTGIS_VERSION%%/'"$postgisVersion"'/g; s/%%PGROUTING_VERSION%%/'"$pgroutingVersion"'/g; s/%%PGROUTING_SHA256%%/'"$srcSha256"'/g; s/%%BOOST_VERSION%%/'"$boostVersion"'/g; s/%%CDAL_VERSION%%/'"$cdalVersion"'/g; ' "$version/Dockerfile"
        mv "$version/README.md.template" "$version/README.md"
        sed -i 's/%%PG_MAJOR%%/'"$postgresVersion"'/g; s/%%POSTGIS_VERSION%%/'"$postgisVersion"'/g; s/%%PGROUTING_VERSION%%/'"$pgroutingVersion"'/g;' "$version/README.md"
        mv "$version/docker-compose.yml.template" "$version/docker-compose.yml"
        sed -i 's/%%PG_MAJOR%%/'"$postgresVersion"'/g; s/%%POSTGIS_VERSION%%/'"$postgisVersion"'/g; s/%%PGROUTING_VERSION%%/'"$pgroutingVersion"'/g;' "$version/docker-compose.yml"
        mv "$version/extra/Dockerfile.template" "$version/extra/Dockerfile"
        sed -i 's/%%PG_MAJOR%%/'"$postgresVersion"'/g; s/%%POSTGIS_VERSION%%/'"$postgisVersion"'/g; s/%%PGROUTING_VERSION%%/'"$pgroutingVersion"'/g; s/%%PQXX_VERSION%%/'"$pqxxVersion"'/g;' "$version/extra/Dockerfile"
    )
done

