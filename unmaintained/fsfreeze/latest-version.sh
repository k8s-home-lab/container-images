#!/usr/bin/env bash

version=$(curl -sX GET "https://pkgs.alpinelinux.org/packages?name=util-linux&branch=v3.14&arch=x86_64" | grep -oP '(?<=<td class="version">)[^<]*')
printf "%s" "${version}"
