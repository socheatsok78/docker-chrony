# About
Just another container image for running NTP Server using `chrony` with support for Linux capabilities using `SYS_TIME` & `IPC_LOCK`.

This container runs [chrony](https://chrony-project.org/) on [Alpine Linux](https://alpinelinux.org/).

[Source](https://github.com/socheatsok78/docker-chrony) | [Docker Hub](https://hub.docker.com/r/socheatsok78/chrony)

## What is Chrony?
[chrony](https://chrony-project.org/) is a versatile implementation of the Network Time Protocol (NTP). It can synchronise the system clock with NTP servers, reference clocks (e.g. GPS receiver), and manual input using wristwatch and keyboard. It can also operate as an NTPv4 (RFC 5905) server and peer to provide a time service to other computers in the network.

[Source] | [Docker Hub] | [GitHub Container Registry]

## Image

| Registry                    | Image                       |
| --------------------------- | --------------------------- |
| [Docker Hub]                | socheatsok78/chrony         |
| [GitHub Container Registry] | ghcr.io/socheatsok78/chrony |


[Source]: https://github.com/socheatsok78/docker-chrony
[Docker Hub]: https://hub.docker.com/r/socheatsok78/chrony
[GitHub Container Registry]: https://github.com/socheatsok78/docker-chrony/pkgs/container/chrony

Following platforms for this image are available:

```bash
$ docker run --rm mplatform/mquery socheatsok78/chrony:latest

# Image: socheatsok78/chrony:latest
#  * Manifest List: Yes (Image type: application/vnd.oci.image.index.v1+json)
#  * Supported platforms:
#    - linux/amd64
#    - linux/arm64
```

## Releases

The release versioning scheme is based on **Alpine** releases, and it will follow the same versioning as the base image. The build matrix is generated using [`actions-matrix/alpine-matrix-action`](https://github.com/marketplace/actions/alpine-matrix-action) action.

Currently, the following versions are available:
- `latest`
- `edge`
- `3.20`
- `3.19`

> [!IMPORTANT]
> The release is automated on a weekly basis, and if there is a new version of the base image, the release will build and push the new version following the base image version.

## Usage

```bash
docker run --name=chrony \
    --publish=123:123/udp \
    --cap-add=SYS_TIME \
    --cap-add=IPC_LOCK \
  socheatsok78/chrony:3.20

# Deploy to a Docker Swarm cluster
docker service create --name=chrony \
    --publish=123:123/udp \
    --cap-add=SYS_TIME \
    --cap-add=IPC_LOCK \
    --mode=global \
  socheatsok78/chrony:3.20
```

## Configure Chrony
You can configure chrony by setting the following environment variables:

### Configure NTP Servers

By default, the container will use `DEFAULT_NTP_POOL_ADDR` environment variable to set the default NTP server. You can set this environment variable to the NTP server you want to use.

Alternatively, If you want to use multiple of other different NTP servers, you can set the following environment variables:
- `NTP_SERVER_COUNT`: Number of NTP servers to use. (Default unset)
- `NTP_SERVER_#_ADDR`: NTP Server `#` address. (Required, if `NTP_SERVER_COUNT` > 0)
- `NTP_SERVER_#_NTS`: Enable NTS (Network Time Security) for NTP Server `#`. (Optional, can be `true` or `false`)

> [!WARNING]
> The `DEFAULT_NTP_POOL_ADDR` environment variable will be ignored if `NTP_SERVER_COUNT` is set.

### Chronyd Options

- `LOGLEVEL`: Log level. Default: `0`
  The following levels can to specified: 0 (informational), 1 (warning), 2 (non-fatal error), and 3 (fatal error)
- `NOCLIENTLOG`: This option disables logging of client requests and responses. Default: `false`
  > Specifies that client accesses are not to be logged. Normally they are logged, allowing statistics to be reported using the clients command in chronyc. This option also effectively disables server support for the NTP interleaved mode.

### Advanced Configurations
Some advanced configurations are not documented here, please take a look at the following files:
- [rootfs/etc/s6-overlay/scripts/chronyd-init](https://github.com/socheatsok78/docker-chrony/raw/main/rootfs/etc/s6-overlay/scripts/chronyd-init)
- [rootfs/etc/s6-overlay/s6-rc.d/chronyd/run](https://github.com/socheatsok78/docker-chrony/raw/main/rootfs/etc/s6-overlay/s6-rc.d/chronyd/run)

## NTP Pool Project

<img src="https://github.com/socheatsok78/docker-chrony/raw/main/.github/assets/ntppool.png" width="64px" /><br/>

By default, this container will syncronize time from `pool.ntp.org` provided by the [NTP Pool Project](https://www.ntppool.org/). You can change the default NTP server by setting the `DEFAULT_NTP_POOL_ADDR` environment variable.

By using NTP Pool Project, chances are you will connect to server raning from Stratum 1 to Stratum 4 servers depending on your location.

### Public NTP Servers

| Name              | NTP Server            | Website                                        |
| ----------------- | --------------------- | ---------------------------------------------- |
| Cloudflare NTP    | `time.cloudflare.com` | [Website](https://www.cloudflare.com/time/)    |
| Google Public NTP | `time.google.com`     | [Website](https://developers.google.com/time/) |
| NTP Pool Project  | `pool.ntp.org`        | [Website](https://www.ntppool.org/)            |

**Other NTP Servers:**
| Name          | NTP Server          | Website                                                                              |
| ------------- | ------------------- | ------------------------------------------------------------------------------------ |
| Facebook NTP  | `time.facebook.com` | [Website](https://engineering.fb.com/2020/03/18/production-engineering/ntp-service/) |
| Apple NTP     | `time.apple.com`    |                                                                                      |
| Microsoft NTP | `time.windows.com`  |                                                                                      |

> [!NOTE]
> If you are looking for Stratum One servers, you can check the following sites:
> - https://support.ntp.org/Servers/StratumOneTimeServers
> - https://www.advtimesync.com/docs/manual/stratum1.html

## Monitoring

The metrics are served by [SuperQ/chrony_exporter](https://github.com/SuperQ/chrony_exporter), available at `/metrics` on `9123` port. e.g. `http://localhost:9123/metrics`

There is also a dashboard available for Grafana [here](https://grafana.com/grafana/dashboards/19186-chrony/).

## Container Capabilities
The container can be configured to perform the following actions, and all of them are optional features.

### Set the capability to update system time
With `SYS_TIME` capability, this allows the container to update the system time. By default, this capability is not set. Once the `--cap-add SYS_TIME` provided to the container, `chrony` will be able to update the system time if necessary.

You can disable this feature by setting the `SKIP_SETCAP_SYS_TIME` environment variable to `true`.

### Set the capability to lock memory
With `IPC_LOCK` capability, this allows the container to lock memory. By default, this capability is not set. Once the `--cap-add IPC_LOCK` provided to the container, `chrony` will be able to lock memory and prevent it from being swapped out.

You can disable this feature by setting the `SKIP_SETCAP_IPC_LOCK` environment variable to `true`.

> [!NOTE]
> You can read more about **Runtime privilege and Linux capabilities** in the documentation [here](https://docs.docker.com/engine/containers/run/#runtime-privilege-and-linux-capabilities).

## Important Notes

You may need to disable the host `Automatic Date & Time` setting to prevent the host from syncing time with the NTP server, instead, let the container handle the time sync.

Here an example of how to disable the `Automatic Date & Time` setting on Ubuntu:

```sh
# Check the NTP service status
timedatectl status

# Disable the NTP service
sudo timedatectl set-ntp 0

# Enable the NTP service
sudo timedatectl set-ntp 1
```

## License
Licensed under the GNU General Public License v3.0.
See [LICENSE](https://github.com/socheatsok78/docker-chrony/raw/main/LICENSE) for more information.
