#!/bin/sh


printf "PUBLIC_DOMAIN=$PUBLIC_DOMAIN
PLEX_PUBLIC_PORT=$PLEX_PUBLIC_PORT
PRIVATE_WEB_DOMAIN=$(awk 'NR==1 {print $1}' /etc/hosts)" > /config/transcoderProvider.properties

set -e
exec runsvdir /etc/sv
