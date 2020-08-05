FROM ubuntu:18.04

COPY  ./scripts /home/scripts

RUN set -x && \
    apt-get update -y && \
    apt-get install curl zip -y && \
    curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf - -C /home