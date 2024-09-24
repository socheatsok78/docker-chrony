# About
Just another container image for running NTP Server using `chrony` with support for Linux capabilities using `SYS_TIME` & `IPC_LOCK`.

This container runs [chrony](https://chrony-project.org/) on [Alpine Linux](https://alpinelinux.org/).

## What is Chrony?
[chrony](https://chrony-project.org/) is a versatile implementation of the Network Time Protocol (NTP). It can synchronise the system clock with NTP servers, reference clocks (e.g. GPS receiver), and manual input using wristwatch and keyboard. It can also operate as an NTPv4 (RFC 5905) server and peer to provide a time service to other computers in the network.

## Usage

```sh
docker run --name=chrony \
    --publish=123:123/udp \
    --cap-add SYS_TIME \ # Allow the container to update system time
    --cap-add IPC_LOCK \ # Allow the container to lock memory
    --tmpfs=/etc/chrony:rw,mode=1750 \
    --tmpfs=/run/chrony:rw,mode=1750 \
    --tmpfs=/var/lib/chrony:rw,mode=1750 \
  socheatsok78/chrony:3.20
```

## Configure Chrony
You can configure chrony by setting the following environment variables:

### Configure NTP Servers

By default, the container will use `DEFAULT_NTP_SERVER_ADDR` environment variable to set the default NTP server. You can set this environment variable to the NTP server you want to use.

Alternatively, If you want to use multiple of other different NTP servers, you can set the following environment variables:
- `NTP_SERVER_COUNT`: Number of NTP servers to use. (Default unset)
- `NTP_SERVER_#_ADDR`: NTP Server `#` address. (Required, if `NTP_SERVER_COUNT` > 0)
- `NTP_SERVER_#_NTS`: Enable NTS (Network Time Security) for NTP Server `#`. (Optional, can be `true` or `false`)

> [!WARNING]
> The `DEFAULT_NTP_SERVER_ADDR` environment variable will be ignored if `NTP_SERVER_COUNT` is set.

### Chronyd Options

- `LOGLEVEL`: Log level. Default: `0`
  The following levels can to specified: 0 (informational), 1 (warning), 2 (non-fatal error), and 3 (fatal error)
- `NOCLIENTLOG`: This option disables logging of client requests and responses. Default: `false`
  > Specifies that client accesses are not to be logged. Normally they are logged, allowing statistics to be reported using the clients command in chronyc. This option also effectively disables server support for the NTP interleaved mode.

## NTP Pool Project

<img src=".github/assets/ntppool.png" width="64px" /><br/>

By default, this container will syncronize time from `pool.ntp.org` provided by the [NTP Pool Project](https://www.ntppool.org/). You can change the default NTP server by setting the `DEFAULT_NTP_SERVER_ADDR` environment variable.

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

## Prometheus Metrics

The metrics are served by [SuperQ/chrony_exporter](https://github.com/SuperQ/chrony_exporter), available at `http://<container-ip>:9123/metrics`.

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

## License
Licensed under the GNU General Public License v3.0.
See [LICENSE](LICENSE) for more information.
