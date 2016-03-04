#!/bin/sh

printf "PUBLIC_DOMAIN=$PLEX_PUBLIC_DOMAIN
PRIVATE_WEB_DOMAIN=$(awk 'NR==1 {print $1}' /etc/hosts)" > /config/transcoderProvider.properties
/usr/lib/jvm/java-8-openjdk-amd64/bin/java -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=6006 -jar /usr/bin/PlexCloudTranscoding.jar -digitalOceanRegion $DO_REGION -digitalOceanToken $DO_TOKEN \
    -sshkey $SSH_PUB_KEY_PATH -transcodeFileServerDomainName $TRANSCODE_DOMAIN \
    -transcodeFileServerPort $TRANSCODE_PORT -transcodeFileServerUserPass $TRANSCODE_USER:$TRANSCODE_PASS \
    -webServerDomainName $ORCHESTRATOR_DOMAIN -webServerPort $ORCHESTRATOR_PORT

