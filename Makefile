SHELL = /bin/bash

IMAGE_NAME ?= k8s-dns
IMAGE_TAG  ?= testing

BUILD_TIMEZONE       ?= Europe/Berlin
BUILD_VCS_REFERENCE   = $(shell git rev-parse --short HEAD)
BUILD_VCS_VERSION     = $(shell git describe --tags --contains --always)

.PHONY: default run

default:
	@ docker build .                                           \
		-t $(IMAGE_NAME):$(IMAGE_TAG)                          \
		--build-arg IMAGE_NAME=$(IMAGE_NAME)                   \
		--build-arg BUILD_TIMEZONE=$(BUILD_TIMEZONE)           \
		--build-arg BUILD_VCS_REFERENCE=$(BUILD_VCS_REFERENCE) \
		--build-arg BUILD_VCS_VERSION=$(BUILD_VCS_VERSION)

run:
	@- docker run --rm -it                        \
		-p 8053:8053/udp -p 8053:8053/tcp         \
		-v $(shell pwd)/configuration/:/etc/bind/ \
		$(IMAGE_NAME):$(IMAGE_TAG)
