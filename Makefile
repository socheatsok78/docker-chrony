it: build run
build:
	docker buildx bake dev --load
run:
	docker run --rm \
		-p 123:123/udp \
		-p 9123:9123 \
		--tmpfs=/etc/chrony:rw,mode=1750 \
		--tmpfs=/run/chrony:rw,mode=1750 \
		--tmpfs=/var/lib/chrony:rw,mode=1750 \
	socheatsok78/chrony:dev
