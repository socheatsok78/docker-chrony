ARG ALPINE_VERSION=latest
ARG S6_OVERLAY_VERSION=v3.2.0.0-minimal

FROM quay.io/superq/chrony-exporter AS chrony-exporter
FROM socheatsok78/s6-overlay-distribution:${S6_OVERLAY_VERSION} AS s6-overlay

FROM alpine:${ALPINE_VERSION}
RUN apk add --no-cache bash chrony curl libcap tzdata
COPY --link --from=s6-overlay / /
COPY --link --from=chrony-exporter /bin/chrony_exporter /bin/chrony_exporter
EXPOSE 123/udp
EXPOSE 9123/tcp
# HEALTHCHECK CMD /docker-healthcheck.sh
HEALTHCHECK CMD curl -s http://127.0.0.1:9123 >/dev/null || exit 1
ENTRYPOINT [ "/init-shim" ]
CMD [ "sleep", "infinity" ]

ADD rootfs /

VOLUME /etc/chrony/sources.d
VOLUME /var/lib/chrony
VOLUME /var/log/chrony
