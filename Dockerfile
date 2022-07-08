FROM docker.io/ubuntu:22.04

ARG IMAGE_NAME BUILD_VCS_VERSION BUILD_VCS_REFERENCE BUILD_TIMEZONE
ENV USER=bind GROUP=bind DEBIAN_FRONTEND=noninteractive

LABEL org.opencontainers.image.version=${BUILD_VCS_VERSION}
LABEL org.opencontainers.image.revision=${BUILD_VCS_REFERENCE}
LABEL org.opencontainers.image.title=${IMAGE_NAME}
LABEL org.opencontainers.image.vendor="Georg Lauterbach"
LABEL org.opencontainers.image.authors="Georg Lauterbach"
LABEL org.opencontainers.image.licenses="GPL-3.0"
LABEL org.opencontainers.image.description="BIND9 DNS Server for containers running in Kubernetes"
LABEL org.opencontainers.image.url="https://github.com/georglauterbach/k8s-dns"
LABEL org.opencontainers.image.documentation="https://github.com/georglauterbach/k8s-dns/blob/main/README.md"
LABEL org.opencontainers.image.source="https://github.com/georglauterbach/k8s-dns"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
WORKDIR /

RUN apt-get -qq update \
	&& apt-get -qq dist-upgrade \
	&& apt-get -qq install --no-install-recommends --no-install-suggests bind9 tzdata \
	&& apt-get -qq purge --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
	&& apt-get -qq autoremove \
	&& apt-get -qq autoclean \
	&& apt-get -qq clean \
	&& rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/log/named/ /etc/bind/ \
	&& chown ${USER}:${GROUP} /var/log/named \
	&& chmod 0755 /var/log/named \
	&& ln -fs "/usr/share/zoneinfo/${BUILD_TIMEZONE}" /etc/localtime \
	&& dpkg-reconfigure -f noninteractive tzdata 2>&1

COPY ./scripts/entrypoint.sh /

USER bind
EXPOSE 8053/tcp 8053/udp

ENTRYPOINT ["/bin/bash"]
CMD ["/entrypoint.sh"]
