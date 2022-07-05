SHELL = /bin/bash

BUILD_NAME   ?= k8s-dns
TAG          ?= testing
BUILD_TZ     ?= Europe/Berlin
BUILD_VCS_REF = $(shell git rev-parse --short HEAD)
BUILD_VCS_VER = $(shell git describe --tags --contains --always)

default:
	@ docker build .                               \
		-t $(BUILD_NAME):$(TAG)              \
		--build-arg BUILD_NAME=$(BUILD_NAME)       \
		--build-arg TAG=$(TAG)         \
		--build-arg BUILD_TZ=$(BUILD_TZ)           \
		--build-arg BUILD_VCS_REF=$(BUILD_VCS_REF) \
		--build-arg BUILD_VCS_VER=$(BUILD_VCS_VER) \

run:
	@- docker run                         \
		--rm -it                          \
		-p 8053:8053/udp -p 8053:8053/tcp \
		-v $(shell pwd)/configuration/named.conf:/etc/bind/named.conf \
		$(BUILD_NAME):$(TAG)
