# `k8s-dns`

Easy yet powerful BIND9 DNS server for containers running on Alpine with Bash. Built with K8s-support in mind.

This project aims to supply the user with a dead-simple container that is highly customizable. We believe that users can easily write BIND9 configuration files themselves - therefore, we do not provide environment variables that will be parsed into configuration files.

## Usage

[CI/CD](https://github.com/georglauterbach/k8s-dns/actions) will automatically build and push new images to container registries. Currently, the following registries are supported:

1. [DockerHub](https://hub.docker.com/r/andevour/k8s-dns)
2. [GitHub Container Registry (GHCR)](https://github.com/georglauterbach/k8s-dns/pkgs/container/k8s-dns)

All workflows are using the tagging convention listed below. It is subsequently applied to all images.

| Event                        | Image Tags                    |
|------------------------------|-------------------------------|
| `push` on `main`             | `edge`                        |
| `push` a tag (e.g. `v2.4.3`) | `2.4.3`, `2.4`, `2`, `latest` |

## Configuration

### User-Supplied Configuration

Your base configuration can be mounted to `${NAMED_MAIN_CONFIGURATION_FILE}` (see [environment variable section](#named_main_configuration_file)). The entrypoint script will execute the `named` service and provide the aforementioned file as the configuration file. As a consequence, you can configure everything yourself. A default configuration can be found under [`configuration/namd.conf`](configuration/named.conf).

### Custom Script

If you want to run a custom script before the DNS server is started, you can mount a script to `${USER_PATCHES_FILE}` (see [environment variable section](#user_patches_file)). This script will be `source`d before the DNS server is started, if it is present. If you provide a function called `user-patches-main`, the function is called. This way, you can even adjust environment variables configured in the entrypoint script. Have a look at the [entrypoint script](./scripts/entrypoint.sh) to see which variables are declared and what you can adjust.

### Environment Variables

The following list of environment variables can be used to adjust the container's behavior.

#### `NAMED_MAIN_CONFIGURATION_FILE`

This sets the main configuration file that the `named` service is provided with during startup. The default is `/etc/bind/named.conf`.

#### `USER_PATCHES_FILE`

If you want to provide a custom script that is run right before the `named` service is started, you can change the location of this script with this variable. The default is `/user-patches.sh`.

## Container Settings / Metrics

The containers listens on port `8053`, for both UDP and TCP. You should be able to run this container with a read-only root filesystem. The default user is `bind` (`101:101`). Therefore, you can run this container with a non-root user. If you need to change the time zone though, you will need to run as root.

| Metric       | Value                          |
| :----------: | :----------------------------: |
| open port(s) | `8053` (TCP & UDP)             |
| default user | `bind` (UID `101` & GID `101`) |

## Examples of Use

### In Conjunction with CoreDNS

In K8s, [CoreDNS](https://coredns.io/) is a de-facto standard for cluster-wide DNS. CoreDNS is easy to configure for most use cases. However, if you need a more complex recursive resolver that may be able to use DNSSEC, you would need to compile CoreDNS with the unbound plugin yourself. With this container though, you can resolve queries recursively and with DNSSEC. Here is a small example of a `Corefile` that forwards queries, that may need recursive resolving, to this container:

``` CONF
dnswl.org spamhaus.org {
    forward . dns://<K8S-DNS-SERVICE-CLUSTER-IP-ADDRESS>:8053 {
      prefer_udp
    }
}

.:53 {
    kubernetes cluster.local in-addr.arpa ip6.arpa {
      pods verified
      fallthrough in-addr.arpa ip6.arpa
      ttl 30
    }

    forward . tls://1.1.1.1 tls://1.0.0.1 {
      tls_servername cloudflare-dns.com
      health_check 30s
    }
}
```

This is especially useful because CoreDNS can handle cluster-specific traffic very well. You would not want to handle cluster-specific DNS traffic with this container alone.
