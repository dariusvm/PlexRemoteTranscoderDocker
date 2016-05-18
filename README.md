# PlexRemoteTranscoderDocker

This docker use my project of PlexRemoteTranscoderOrchestrator
To create a automatic system that allow us to pass thru all the cpu intensive video encoding
to a remote virtual machines in DigitalOcean where we pay per hour of use.
So we can handle as many encodings as our network can handle.


This docker consist of two dockers:
-Plex docker modified to wrap the executable "Plex New Transcoder" 
-A Transcoder Orchestrator that create/delete/manage the DO machines and the intercomunication between Plex and DO


## What we need?
-For now to receive video transcode data from DO i am using NFS, it's not a big deal but NFS needs to have installed
 the nfs-kernel-server in our kernel. So maybe we can have problems depends on the machine with my docker.
-We need powerfull internet connection we will send the video twice, why?
 Transcoder Orchestrator send to DO, Do encode and send back to Plex Server,Plex Server send to client.(think about it, it's imoportant)
-cpu atless 1K benchmark power to run plex server, I tested in diferent cloud prividers, DO,aruba,scaleway, work perfect.


##Things that you should know
-First deploy, the orchestrator docker need some minutes to generate a image to your DO account to avoid install nothing for your side.
 So keep calm and wait, you will now that it's done when in your DO account you see a image called PlexRemoteTranscoder
-If you close the dockers and you have running DO VM, you will need to destroy it manually
-I didn't know how to fix it so for now when you play a video that require transcode, first time the transcode will be executed in the
 plex server, when the DO is ready, the video will stop and you will click again to play the video, but this time will be transcoded by DO.
 I have a proof of concept of using a fake temporal video saying something like "wait we are loading your video", 
 but plex make a mess with the video duration. We can discuss to diferent solution guys.
 
Here i give you a docker-compose to avoid some of your time trying to figure out how it works 

```
PlexMainServer:
  environment:
    VERSION: plexpass
  image: segator/plex
  volumes:
  #volumes where we have moves tvshows homemade videos music etc..
  - /server/media/movies:/data/movies:ro
  - /server/media/tvshows:/data/tvshows:ro
  #Volume where we save our plex database
  - /server/docker/plex/config/:/config
    
  #Volume used to store temporal files generated by transcoder (we must configure plex from the web ui to save temporals to /transcode)
  - /server/docker/plex/transcode:/transcode
  net: host
plexTranscoderOrchestrator:
  ports:
  - 8800:8800/tcp
  - 111:111/udp
  - 2049:2049/tcp
  - 111:111/tcp
  - 15300:15300/tcp
  - 15300:15300/udp
  environment:  
    #Domain used by DigitalOcean to transfer transcoded video to your Plex Server
    PUBLIC_DOMAIN: my.public.domain.com
    #Port used by DigitalOcean to transfer transcoded video to your Plex Server
    PLEX_PUBLIC_PORT: '32400'
    #this is where you want to deploy DigitalOcean machines(use the nearest from your plex server location)
    DO_REGION: ams2 
    #This is your digitalOcean admin token
    DO_TOKEN: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
    #This is the ssh key used by the DO VM to autoconnect using SSH 
    SSH_PUB_KEY_PATH: /config/.ssh/id_rsa.pub
    #same as PLEX_PUBLIC_PORT but this port is for DO machines notification of their current status
    ORCHESTRATOR_PUBLIC_PORT: '8800'
    #Where is the movies tvshows
    MEDIA_DIRECTORY: /data
    #In seconds, when the transcoder it's not used in this time, will be destroyed
    TRANSCODER_TIMEOUT: 600
  image: segator/transcoder_orchestrator
  links:
  - PlexMainServer:plex
  privileged: true
  volumes_from:
  - PlexMainServer
```


