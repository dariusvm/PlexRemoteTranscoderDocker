#!/bin/bash

wrapper=`md5sum /defaults/plex_wrapper_transcoder | awk '{print $1}'`
current=`md5sum /usr/lib/plexmediaserver/Resources/Plex\ New\ Transcoder | awk '{print $1}'`

if [ "$wrapper" != "$current" ]; then
   echo "detected Plex Transcoder are not wrapped!! lets replace to remote transcoder"
   mv /usr/lib/plexmediaserver/Resources/Plex\ New\ Transcoder /usr/lib/plexmediaserver/Resources/plex_transcoder
   cp /defaults/plex_wrapper_transcoder /usr/lib/plexmediaserver/Resources/Plex\ New\ Transcoder
   chmod +x /usr/lib/plexmediaserver/Resources/Plex\ New\ Transcoder
fi
