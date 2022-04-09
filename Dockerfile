FROM --platform=${TARGETPLATFORM} alpine:3.15 as builder
ARG TAG

RUN apk add --no-cache wget unzip

WORKDIR /root

COPY get_url.sh .

RUN set -ex && \
    chmod +x get_url.sh &&\
    /bin/sh get_url.sh

FROM --platform=${TARGETPLATFORM} alpine:3.15
COPY --from=builder /usr/bin/qbittorrent-nox /usr/bin

RUN apk add --no-cache ca-certificates su-exec tzdata python3

ENV WEBUIPORT=28080

RUN set -ex && \
    mkdir /etc/qbittorrent && \
    mkdir /root/downloads && \
    mkdir /root/torrents

VOLUME ["/etc/qbittorrent"]
VOLUME ["/root/downloads"]

WORKDIR /root/downloads

ENV TZ=Asia/Shanghai
RUN cp /usr/share/zoneinfo/${TZ} /etc/localtime && \
	echo "${TZ}" > /etc/timezone

ENV PUID=1000 PGID=1000
ENV CONFIGURATION=/etc/qbittorrent
ENV DOWNLOADS=/root/downloads
ENV TORRENTS=/root/torrents

COPY docker-entrypoint.sh /bin/entrypoint.sh
RUN chmod a+x /bin/entrypoint.sh
ENTRYPOINT ["/bin/entrypoint.sh"]

EXPOSE ${WEBUIPORT}

CMD /usr/bin/qbittorrent-nox \
    --profile=/etc/qbittorrent-ee \
    -webui-port=${WEBUIPORT}