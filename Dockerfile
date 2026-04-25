# syntax=docker.io/docker/dockerfile:1

FROM docker.io/alpine@sha256:5b10f432ef3da1b8d4c7eb6c487f2f5a8f096bc91145e68878dd4a5019afde11

ARG VCS_VERSION=edge
ARG VSC_REVISION=unknown

ENV USER=named
ENV GROUP=named

# https://snyk.io/de/blog/how-and-when-to-use-docker-labels-oci-container-annotations/
LABEL org.opencontainers.image.title="k8s-dns"
LABEL org.opencontainers.image.description="BIND9 on Alpine"
LABEL org.opencontainers.image.source="https://github.com/georglauterbach/k8s-dns"
LABEL org.opencontainers.image.revision="${VSC_REVISION}"
LABEL org.opencontainers.image.base.digest="5b10f432ef3da1b8d4c7eb6c487f2f5a8f096bc91145e68878dd4a5019afde11"
LABEL org.opencontainers.image.base.name="docker.io/alpine"
LABEL org.opencontainers.image.version="${VCS_VERSION}"

WORKDIR /

ARG BIND_VERSION=9.20.22-r0

RUN apk add --no-cache "bind=${BIND_VERSION}" "bind-tools=${BIND_VERSION}" \
    && mkdir -p /etc/bind/       /var/cache/named \
    && chown -R ${USER}:${GROUP} /var/cache/named

COPY ./scripts/entrypoint.sh    /usr/local/bin/entrypoint.sh

USER ${USER}
EXPOSE 53/tcp 53/udp 8053/tcp 8053/udp

ENTRYPOINT ["/bin/sh", "/usr/local/bin/entrypoint.sh"]
