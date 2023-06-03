#!/usr/bin/env bash

version=$(curl -sX GET "https://api.github.com/repos/nzbget/nzbget/releases" | jq --raw-output '. | map(select(.prerelease == true))[0].tag_name')
version="${version#*v}"
version="${version#*release-}"
printf "%s" "${version}"
