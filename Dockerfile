FROM docker.io/debian:11-slim

ARG BUILD_NAME BUILD_VCS_VER BUILD_VCS_REF BUILD_TZ
ARG DEBIAN_FRONTEND=noninteractive

LABEL org.opencontainers.image.version=${BUILD_VCS_VER}
LABEL org.opencontainers.image.revision=${BUILDVCS_REF}
LABEL org.opencontainers.image.title=${BUILD_NAME}
LABEL org.opencontainers.image.vendor="Georg Lauterbach"
LABEL org.opencontainers.image.authors="Georg Lauterbach"
LABEL org.opencontainers.image.licenses="GPL-3.0"
LABEL org.opencontainers.image.description="BIND9 DNS Server for Containers running in Kubernetes"
LABEL org.opencontainers.image.url="https://github.com/georglauterbach/k8s-dns"
LABEL org.opencontainers.image.documentation="https://github.com/georglauterbach/k8s-dns/blob/main/README.md"
LABEL org.opencontainers.image.source="https://github.com/georglauterbach/k8s-dns"

ENV USER=bind
ENV	GROUP=bind

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN \
	apt-get -qq update \
	&& apt-get -qq dist-upgrade \
	&& apt-get install --no-install-recommends --no-install-suggests -y bind9 \
	&& apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
	&& apt-get -qq autoremove \
	&& apt-get -qq autoclean \
	&& apt-get -qq clean \
	&& rm -rf /var/lib/apt/lists/*

RUN \
	mkdir -p /var/log/named/ /etc/bind/ \
	&& chown bind:bind /var/log/named \
	&& chmod 0755 /var/log/named \
	&& ln -fs "/usr/share/zoneinfo/${BUILD_TZ}" /etc/localtime \
	&& dpkg-reconfigure -f noninteractive tzdata

WORKDIR /
COPY ./scripts/entrypoint.sh /

EXPOSE 8053/tcp
EXPOSE 8053/udp

USER bind

ENTRYPOINT  ["/entrypoint.sh"]
