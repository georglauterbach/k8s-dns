# syntax=docker.io/docker/dockerfile:1

FROM docker.io/alpine:3.16

ARG IMAGE_NAME=k8s-dns
ARG BUILD_VCS_VERSION=edge
ARG BUILD_VCS_REFERENCE=unknown
ARG BUILD_TIMEZONE=Europe/Berlin
ENV USER=named
ENV GROUP=named

LABEL org.opencontainers.image.version ${BUILD_VCS_VERSION}
LABEL org.opencontainers.image.revision ${BUILD_VCS_REFERENCE}
LABEL org.opencontainers.image.title ${IMAGE_NAME}
LABEL org.opencontainers.image.vendor "Georg Lauterbach"
LABEL org.opencontainers.image.authors "Georg Lauterbach"
LABEL org.opencontainers.image.licenses "GPL-3.0"
LABEL org.opencontainers.image.description "BIND9 DNS Server for containers running in Kubernetes"
LABEL org.opencontainers.image.url "https://github.com/georglauterbach/k8s-dns"
LABEL org.opencontainers.image.documentation "https://github.com/georglauterbach/k8s-dns/blob/main/README.md"
LABEL org.opencontainers.image.source "https://github.com/georglauterbach/k8s-dns"

SHELL ["/bin/ash", "-e", "-u", "-c"]
WORKDIR /

RUN <<"EOM"
	apk add --no-cache bind bind-tools tzdata bash
	mkdir -p /var/cache/named /etc/bind/
	chown -R ${USER}:${GROUP} /var/cache/named
	ln -fs "/usr/share/zoneinfo/${BUILD_TIMEZONE}" /etc/localtime
EOM

COPY ./VERSION ./scripts/entrypoint.sh /

USER ${USER}
EXPOSE 8053/tcp 8053/udp

ENTRYPOINT ["/bin/bash"]
CMD ["/entrypoint.sh"]
