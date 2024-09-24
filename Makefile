it: build run
build:
	docker buildx bake dev --load
run:
	docker run --rm \
		-p 123:123/udp \
		-p 9123:9123 \
		-e S6_VERBOSITY=2 \
		--tmpfs=/etc/chrony:rw,mode=1750 \
		--tmpfs=/run/chrony:rw,mode=1750 \
		--tmpfs=/var/lib/chrony:rw,mode=1750 \
	socheatsok78/chrony:dev

deploy:
	docker stack deploy --prune -c docker-stack.yml ntp 
remove:
	docker stack rm ntp
