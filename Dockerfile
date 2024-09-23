ARG ALPINE_VERSION=latest

FROM quay.io/superq/chrony-exporter AS chrony-exporter

FROM alpine:${ALPINE_VERSION}
RUN apk add --no-cache bash chrony curl libcap tzdata
COPY --from=chrony-exporter /bin/chrony_exporter /bin/chrony_exporter
EXPOSE 123/udp
EXPOSE 9123/tcp
HEALTHCHECK CMD curl -s http://127.0.0.1:9123 >/dev/null || exit 1

# https://github.com/socheatsok78/s6-overlay-installer
ARG S6_OVERLAY_VERSION=v3.2.0.0
ARG S6_OVERLAY_INSTALLER=main/s6-overlay-installer-minimal.sh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/socheatsok78/s6-overlay-installer/${S6_OVERLAY_INSTALLER})"
ENTRYPOINT [ "/init-shim" ]
CMD [ "sleep", "infinity" ]

ADD rootfs /
