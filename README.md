# `k8s-dns`

Easy yet powerful BIND9 DNS server for containers running in Kubernetes. Built with K8s-support in mind.

## Configuration

### User-Supplied

Your configuration should be mounted to `/etc/bind/namd.conf`. The entrypoint script will execute the `named` service and provide the aforementioned file as the configuration file. As a consequence, you can configure everything yourself. A default configuration can be found under [`configuration/namd.conf`](configuration/named.conf).

### More

If you want to run a custom script before the DNS server is started, you can mount a script to `/user-patches.sh`. This script will be `source`d (!) before the DNS server is started, if it is present. If you provide a function called `user-patches-main`, the function is called. This way, you can even adjust environment variables configured in the entrypoint script.

## Environment Variables

- `TZ` You can provide this environment variable to set a time zone. You can lookup all available timezones [here](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List).

## Container Settings

The containers listens on port `8053`, for both UDP and TCP. You should be able to run this container with a read-only root filesystem. The default user is `bind` (`101:101`). Therefore, you can run this container with a non-root user. If you need to change the time zone though, you will need to run as root.
