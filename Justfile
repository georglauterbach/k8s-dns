# -----------------------------------------------
# ----  Just  -----------------------------------
# ----  https://github.com/casey/just  ----------
# -----------------------------------------------

set shell          := [ "/bin/sh", "-e", "-u", "-c" ]
set dotenv-load    := false

IMAGE_NAME         := "k8s-dns"
IMAGE_TAG          := `git describe --exact-match --tags 2>/dev/null || echo 'edge'`
BUILD_VSC_REVISION := `git rev-parse HEAD`

[private]
@default:
	just --list

# Build k8s-dns
@build:
	docker build --tag {{IMAGE_NAME}}:{{IMAGE_TAG}}           \
		--build-arg BUILD_VSC_REVISION={{BUILD_VSC_REVISION}} \
		--build-arg BUILD_VCS_VERSION={{IMAGE_TAG}}           \
		.

# Run k8s-dns
[positional-arguments]
@run *arguments: build
	docker run --rm --tty --interactive           \
		-p 8053:8053/udp -p 8053:8053/tcp         \
		-v {{justfile_directory()}}/configuration/:/etc/bind/ \
		{{IMAGE_NAME}}:{{IMAGE_TAG}} {{arguments}}
