# syntax=docker.io/docker/dockerfile:1

FROM docker.io/alpine@sha256:25109184c71bdad752c8312a8623239686a9a2071e8825f20acb8f2198c3f659

ARG VCS_VERSION=edge
ARG VSC_REVISION=unknown

ENV USER=named
ENV GROUP=named

# https://snyk.io/de/blog/how-and-when-to-use-docker-labels-oci-container-annotations/
LABEL org.opencontainers.image.title="k8s-dns"
LABEL org.opencontainers.image.description="BIND9 on Alpine"
LABEL org.opencontainers.image.source="https://github.com/georglauterbach/k8s-dns"
LABEL org.opencontainers.image.revision="${VSC_REVISION}"
LABEL org.opencontainers.image.base.digest="25109184c71bdad752c8312a8623239686a9a2071e8825f20acb8f2198c3f659"
LABEL org.opencontainers.image.base.name="docker.io/alpine"
LABEL org.opencontainers.image.version="${VCS_VERSION}"

WORKDIR /

RUN apk add --no-cache bind bind-tools            \
    && mkdir -p /etc/bind/       /var/cache/named \
    && chown -R ${USER}:${GROUP} /var/cache/named

COPY ./scripts/entrypoint.sh    /usr/local/bin/entrypoint.sh

USER ${USER}
EXPOSE 53/tcp 53/udp 8053/tcp 8053/udp

ENTRYPOINT ["/bin/sh", "/usr/local/bin/entrypoint.sh"]
