# About
Just another container image for running NTP Server using `chrony` with support for Linux capabilities using `SYS_TIME` & `IPC_LOCK`.

This container runs [chrony](https://chrony-project.org/) on [Alpine Linux](https://alpinelinux.org/).

## What is Chrony?
[chrony](https://chrony-project.org/) is a versatile implementation of the Network Time Protocol (NTP). It can synchronise the system clock with NTP servers, reference clocks (e.g. GPS receiver), and manual input using wristwatch and keyboard. It can also operate as an NTPv4 (RFC 5905) server and peer to provide a time service to other computers in the network.

## Configure Chrony
You can configure chrony by setting the following environment variables:

### Configure NTP Servers

By default, the container will use `DEFAULT_NTP_SERVER` environment variable to set the default NTP server.

If you want to use multiple NTP servers, you can set the following environment variables:
- `NTP_SERVER_COUNT`: Number of NTP servers to use. (Default unset)
- `NTP_SERVER_#_ADDR`: NTP Server `#` address. (Required, if `NTP_SERVER_COUNT` > 0)
- `NTP_SERVER_#_NTS`: Enable NTS (Network Time Security) for NTP Server `#`. (Optional, can be `true` or `false`)

### Chronyd Options

- `LOGLEVEL`: Log level. Default: `0`
  The following levels can to specified: 0 (informational), 1 (warning), 2 (non-fatal error), and 3 (fatal error)
- `NOCLIENTLOG`: This option disables logging of client requests and responses. Default: `false`
  > Specifies that client accesses are not to be logged. Normally they are logged, allowing statistics to be reported using the clients command in chronyc. This option also effectively disables server support for the NTP interleaved mode.

## Container Capabilities
The container can be configured to perform the following actions, and all of them are optional features.

### Set the capability to update system time
With `SYS_TIME` capability, this allows the container to update the system time. By default, this capability is not set. Once the `--cap-add SYS_TIME` provided to the container, `chrony` will be able to update the system time if necessary.

You can disable this feature by setting the `SKIP_SETCAP_SYS_TIME` environment variable to `true`.

### Set the capability to lock memory
With `IPC_LOCK` capability, this allows the container to lock memory. By default, this capability is not set. Once the `--cap-add IPC_LOCK` provided to the container, `chrony` will be able to lock memory and prevent it from being swapped out.

You can disable this feature by setting the `SKIP_SETCAP_IPC_LOCK` environment variable to `true`.

## Prometheus Metrics

The container exposes [Prometheus](https://prometheus.io/) metrics at `http://<container-ip>:9123/metrics` by default. The metrics are served by [chrony_exporter](https://github.com/SuperQ/chrony_exporter).

## NTP Pool Project

<img src=".github/assets/ntppool.png" width="64px" /><br/>

By default, this container will syncronize time from `pool.ntp.org`.

## License
Licensed under the GNU General Public License v3.0.  
See [LICENSE](LICENSE) for more information.
