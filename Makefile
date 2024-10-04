# The stack files to include
# if docker-stack.override.yml file exists, include it
DOCKER_STACK_FILES := -c docker-stack.yml
ifneq ("$(wildcard docker-stack.override.yml)","")
	DOCKER_STACK_FILES += -c docker-stack.override.yml
endif

it: dockerhub build
.PHONY: dockerhub
dockerhub:
	@bash dockerhub/README.sh
build:
	docker buildx bake dev --load
run:
	docker run --rm \
		-p 123:123/udp \
		-p 9123:9123 \
		-e S6_VERBOSITY=2 \
		--tmpfs=/etc/chrony:rw,mode=1750 \
		--tmpfs=/var/lib/chrony:rw,mode=1750 \
	socheatsok78/chrony:dev
deploy:
	docker stack deploy --prune $(DOCKER_STACK_FILES) chrony
remove:
	docker stack rm chrony
