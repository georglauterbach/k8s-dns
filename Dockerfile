# syntax=docker.io/docker/dockerfile:1

FROM docker.io/alpine:3.23

ARG IMAGE_NAME=k8s-dns
ARG VCS_VERSION=edge
ARG VSC_REVISION=unknown
ARG BUILD_TIMEZONE=Europe/Berlin
ENV USER=named
ENV GROUP=named

LABEL org.opencontainers.image.version="${VCS_VERSION}"
LABEL org.opencontainers.image.revision="${VSC_REVISION}"
LABEL org.opencontainers.image.title="${IMAGE_NAME}"
LABEL org.opencontainers.image.vendor="Georg Lauterbach"
LABEL org.opencontainers.image.authors="Georg Lauterbach"
LABEL org.opencontainers.image.licenses="GPL-3.0"
LABEL org.opencontainers.image.description="BIND9 DNS server running in a container"
LABEL org.opencontainers.image.url="https://github.com/georglauterbach/k8s-dns"
LABEL org.opencontainers.image.documentation="https://github.com/georglauterbach/k8s-dns/blob/main/README.md"
LABEL org.opencontainers.image.source="https://github.com/georglauterbach/k8s-dns"

SHELL ["/bin/ash", "-e", "-u", "-c"]
WORKDIR /

RUN <<EOM
	apk add --no-cache bind bind-tools tzdata bash
	mkdir -p /var/cache/named /etc/bind/
	chown -R ${USER}:${GROUP} /var/cache/named
	ln -fs "/usr/share/zoneinfo/${BUILD_TIMEZONE}" /etc/localtime
EOM

COPY ./VERSION ./scripts/entrypoint.sh /
COPY ./configuration/named.conf /etc/bind/named.conf

USER ${USER}
EXPOSE 53/tcp 53/udp 8053/tcp 8053/udp

ENTRYPOINT ["/bin/bash"]
CMD ["/entrypoint.sh"]
