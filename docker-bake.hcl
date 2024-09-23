variable "ALPINE_VERSION" { default = "latest" }

target "docker-metadata-action" {}
target "github-metadata-action" {}

target "default" {
    inherits = [
        "docker-metadata-action",
        "github-metadata-action",
    ]
    args = {
        ALPINE_VERSION = "${ALPINE_VERSION}"
    }
    platforms = [
        "linux/amd64",
        "linux/arm64"
    ]
}
target "dev" {
    inherits = [
        "docker-metadata-action",
        "github-metadata-action",
    ]
    args = {
        ALPINE_VERSION = "${ALPINE_VERSION}"
    }
    tags = [
        "socheatsok78/chrony:dev"
    ]
}
