FROM java:8-jdk
MAINTAINER Isaac Aymerich <isaac.aymerich@gmail.com>

COPY entry-point.sh /usr/bin/entry-point.sh
RUN apt-get update && apt-get -y install git maven
RUN cd /tmp/ && git clone https://github.com/segator/PlexRemoteTranscoderOrchestrator.git \
    && cd PlexRemoteTranscoderOrchestrator \
    && mkdir /etc/transcoder_orchestrator \
    && cp -R scripts/* /etc/transcoder_orchestrator \
    && mvn clean install \
    && cd target \
    && cp PlexCloudTranscoding.jar /usr/bin/ && chmod +x /usr/bin/PlexCloudTranscoding.jar \
    && rm -R /tmp/PlexRemoteTranscoderOrchestrator \
    &&  apt-get -y purge git maven && apt-get -y autoremove && rm -rf /root/.m2 && chmod +x /usr/bin/entry-point.sh


EXPOSE 8800 6006

CMD ["entry-point.sh"]
