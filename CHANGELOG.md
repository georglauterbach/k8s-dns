# Changelog

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased](https://github.com/georglauterbach/k8s-dns/compare/v0.2.1...HEAD)

### Changed

- checksum calculation in GH Actions

### Updated

- Alpine bumped from 3.16 to 3.17

## [0.2.1] - 2022-11-24
 
### Added

- a new file called `VERSION` used for checking the version

### Changed

- build arguments use different syntax now
- `org.opencontainers.image.version` & `org.opencontainers.image.revision` have new values

## [0.2.0] - 2022-11-16

### Added

- usage information
- option to set config and user patches file with environment variables

### Changed

- adjusted ENV variable names in [#4](https://github.com/georglauterbach/k8s-dns/pull/4)
- adjusted `Makefile`'s `run` target in [#4](https://github.com/georglauterbach/k8s-dns/pull/4)
- changed to a Ubuntu base image in [#4](https://github.com/georglauterbach/k8s-dns/pull/4)
- refactored `Dockerfile` in [#4](https://github.com/georglauterbach/k8s-dns/pull/4)
- added a changelog [#4](https://github.com/georglauterbach/k8s-dns/pull/4)
- improved entrypoint script (better user-integration)

### Fixed

- updated PR linting workflow to now actually run on PR

## [0.1.0] - 2022-07-05

- initial release

[0.1.0]: https://github.com/georglauterbach/k8s-dns/releases/tag/v0.1.0
[0.2.0]: https://github.com/georglauterbach/k8s-dns/releases/tag/v0.2.0
