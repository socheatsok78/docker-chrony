#!/bin/bash
# find '".' path in README.md and replace it with '"https://github.com/socheatsok78/docker-chrony/raw/main/.'
sed 's/"\./"https:\/\/github.com\/socheatsok78\/docker-chrony\/raw\/main\/\./g' README.md > dockerhub/README.dockerhub.md
