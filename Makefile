SHELL        = /bin/bash
.SHELLFLAGS += -eE -u -o pipefail

IMAGE_NAME  ?= k8s-dns
IMAGE_TAG   ?= testing

BUILD_TIMEZONE       ?= Europe/Berlin
BUILD_VCS_REFERENCE   = $(shell git rev-parse HEAD)
BUILD_VCS_VERSION     = $(shell cat VERSION)

.PHONY: ALWAYS_RUN

default: build
all: build run

build: ALWAYS_RUN
	@ DOCKER_BUILDKIT=1 docker build                         \
		-t $(IMAGE_NAME):$(IMAGE_TAG)                          \
		--build-arg IMAGE_NAME=$(IMAGE_NAME)                   \
		--build-arg BUILD_TIMEZONE=$(BUILD_TIMEZONE)           \
		--build-arg BUILD_VCS_REFERENCE=$(BUILD_VCS_REFERENCE) \
		--build-arg BUILD_VCS_VERSION=$(BUILD_VCS_VERSION)     \
		.

run: ALWAYS_RUN
	@- docker run --rm -it                        \
		-p 8053:8053/udp -p 8053:8053/tcp         \
		-v $(shell pwd)/configuration/:/etc/bind/ \
		$(IMAGE_NAME):$(IMAGE_TAG)
