FROM --platform=${TARGETPLATFORM} debian:11-slim as builder
ARG TAG

ARG DEBIAN_FRONTEND=noninteractive

RUN set -ex && \
    apt-get update && \
    apt-get install --no-install-recommends -y wget unzip && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /root

COPY get_url.sh .

RUN set -ex && \
    chmod +x get_url.sh &&\
    /bin/bash get_url.sh

FROM --platform=${TARGETPLATFORM} debian:11-slim
COPY --from=builder /usr/bin/qbittorrent-nox /usr/bin

ARG DEBIAN_FRONTEND=noninteractive

RUN chmod +x /usr/bin/qbittorrent-nox

RUN set -ex && \
    apt-get update && \
    apt-get install --no-install-recommends -y ca-certificates gosu python3 && \
    rm -rf /var/lib/apt/lists/*

RUN set -ex && \
    mkdir /etc/qbittorrent && \
    mkdir /root/downloads && \
    mkdir /root/torrents

VOLUME ["/etc/qbittorrent"]

ENV TZ=Asia/Shanghai
RUN cp /usr/share/zoneinfo/${TZ} /etc/localtime && \
	echo "${TZ}" > /etc/timezone && \
    dpkg-reconfigure --frontend noninteractive tzdata

ENV PUID=1000 PGID=1000
ENV CONFIGURATION=/etc/qbittorrent
ENV DOWNLOADS=/root/downloads
ENV TORRENTS=/root/torrents

COPY docker-entrypoint.sh /bin/entrypoint.sh
RUN chmod a+x /bin/entrypoint.sh
ENTRYPOINT ["/bin/entrypoint.sh"]

EXPOSE 8080

CMD /usr/bin/qbittorrent-nox \
    --profile=/etc/qbittorrent