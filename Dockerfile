FROM ubuntu:18.04

COPY ./content /home

RUN set -x && \
    chmod +x /home/prepare_build.sh && chmod +x /home/run_build.sh && \
    apt-get update -y && \
    apt-get install curl zip -y && \
    apt-get install lib32gcc1 -y && \
    curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf - -C /home && \
    chmod +x /home/steamcmd.sh && /home/steamcmd.sh +quit    