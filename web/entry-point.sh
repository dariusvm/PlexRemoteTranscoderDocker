#!/bin/sh


printf "PUBLIC_DOMAIN=$PUBLIC_DOMAIN
PLEX_PUBLIC_PORT=$PLEX_PUBLIC_PORT
PRIVATE_WEB_DOMAIN=$(ifconfig eth0 | grep "inet addr:" | cut -d : -f 2 | cut -d " " -f 1)" > /config/transcoderProvider.properties

set -e
exec runsvdir /etc/sv
