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

defaultDebianSuite='bullseye-slim'
declare -A debianSuite=(
    # https://github.com/docker-library/postgres/issues/582
    [11]='bullseye-slim'
    [12]='bullseye-slim'
    [13]='bullseye-slim'
    [14]='bullseye-slim'
    [15]='bullseye-slim'
    [16]='bullseye-slim'
    [17]='bullseye-slim'
    [18]='trixie-slim'
)

defaultPostgisDebPkgNameVersionSuffix='3'
declare -A postgisDebPkgNameVersionSuffixes=(
    [3.0]='3'
    [3.1]='3'
    [3.2]='3'
    [3.3]='3'
    [3.4]='3'
    [3.5]='3'
    [3.6]='3'
)

releaseUrl='https://api.github.com/repos/pgRouting/pgrouting/releases'
versionsJson="$(curl -fsSL "$releaseUrl")"
allVersions="$(
  sed <<< "$versionsJson" \
    -rne 's/^\s+"tag_name": "v([0-9.]+)",$/\1/p' \
    | sort  -ruV
)"

for version in "${versions[@]}"; do
    IFS=- read postgresVersion postgisVersion pgroutingVersion <<< "$version"

    tag="${debianSuite[$postgresVersion]:-$defaultDebianSuite}"
    suite="${tag%%-slim}"
    
    if [ "$suite" = "trixie" ]; then
      boostVersion="1.83.0"
      pqxxVersion="7.10"
    elif [ "$suite" = "bullseye" ]; then
      boostVersion="1.74.0"
      pqxxVersion="6.4"
    else
      echo "Unknown debian version; stop"
      exit 1
    fi

    if [ "$pgroutingVersion" == "develop" ] || [ "$pgroutingVersion" == "main" ]; then
      srcSha256=""
      pgroutingGitHash="$(git ls-remote https://github.com/pgrouting/pgrouting.git heads/${pgroutingVersion} | awk '{ print $1}')"
    else
      ourVersions="$(grep -E "^$pgroutingVersion[.]" <<<"$allVersions")"
      fullVersion=
      for tryVersion in $ourVersions; do
        if srcSha256="$(curl -sSL "https://github.com/pgRouting/pgrouting/archive/v${tryVersion}.tar.gz" | sha256sum | awk '{ print $1 }')" && [ -n "$srcSha256" ]; then
          fullVersion="$tryVersion"
          break
        fi
      done
      if [ -z "$fullVersion" ]; then
        echo >&2 "error: failed to find pgrouting full version for '$version'"
        exit 1
      fi
      # Overwrite pgroutingVersion
      pgroutingVersion="$fullVersion"
      pgroutingGitHash=""
    fi
    (
        set -x
        cp -p -r Dockerfile.template README.md.template docker-compose.yml.template extra "$version/"
        if [ "$pgroutingVersion" == "develop" ] || [ "$pgroutingVersion" == "main" ]; then
          cp -p Dockerfile.develop.template "$version/Dockerfile.template"
        fi
        mv "$version/Dockerfile.template" "$version/Dockerfile"
        sed -i 's/%%PG_MAJOR%%/'"$postgresVersion"'/g; s/%%POSTGIS_VERSION%%/'"$postgisVersion"'/g; s/%%PGROUTING_VERSION%%/'"$pgroutingVersion"'/g; s/%%PGROUTING_SHA256%%/'"$srcSha256"'/g; s/%%PGROUTING_GIT_HASH%%/'"$pgroutingGitHash"'/g; s/%%BOOST_VERSION%%/'"$boostVersion"'/g; ' "$version/Dockerfile"
        mv "$version/README.md.template" "$version/README.md"
        sed -i 's/%%PG_MAJOR%%/'"$postgresVersion"'/g; s/%%POSTGIS_VERSION%%/'"$postgisVersion"'/g; s/%%PGROUTING_VERSION%%/'"$pgroutingVersion"'/g;' "$version/README.md"
        mv "$version/docker-compose.yml.template" "$version/docker-compose.yml"
        sed -i 's/%%PG_MAJOR%%/'"$postgresVersion"'/g; s/%%POSTGIS_VERSION%%/'"$postgisVersion"'/g; s/%%PGROUTING_VERSION%%/'"$pgroutingVersion"'/g;' "$version/docker-compose.yml"
        mv "$version/extra/Dockerfile.template" "$version/extra/Dockerfile"
        sed -i 's/%%PG_MAJOR%%/'"$postgresVersion"'/g; s/%%POSTGIS_VERSION%%/'"$postgisVersion"'/g; s/%%PGROUTING_VERSION%%/'"$pgroutingVersion"'/g; s/%%PQXX_VERSION%%/'"$pqxxVersion"'/g;' "$version/extra/Dockerfile"
        echo "$postgresVersion-$postgisVersion-$pgroutingVersion" > "$version/version.txt"
    )
done

