FROM alpine:latest

# RUN echo https://dl-cdn.alpinelinux.org/alpine/v$(cat /etc/alpine-release | cut -d'.' -f1,2)/main/ >> /etc/apk/repositories \
#     && echo https://dl-cdn.alpinelinux.org/alpine/v$(cat /etc/alpine-release | cut -d'.' -f1,2)/community/ >> /etc/apk/repositories \
#     && echo https://dl-cdn.alpinelinux.org/alpine/edge/testing/ >> /etc/apk/repositories

RUN apk update && apk add --update --no-cache \
    bash \
##    curl \
##    git \
    inotify-tools \
##    make \
##    musl-dev \
##    vim \
##    wget \
&& apk upgrade

COPY logger-tailer.sh /


