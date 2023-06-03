#!/usr/bin/env bash

version=$(curl -sX GET "https://sonarr.servarr.com/v1/update/widowmaker/changes?os=linux&runtime=netcore" | jq --raw-output '.[0].version')
version="${version#*v}"
version="${version#*release-}"
printf "%s" "${version}"
