#Update these when versions change:
TAG ?= docker-17
IMAGE ?= docker.io/docker7777777/util/jenkins-node-docker:$(TAG)

.PHONY: all build uncached push run stop clean

all: build

#Build image with cache
build:
	docker build -t $(IMAGE) .

#Build image wihtout cache
uncached:
	docker build --no-cache -t $(IMAGE) .

#Push image to registry
push: build
	docker push $(IMAGE)

#Run the image
run: build
	docker run --name jenkins-node-docker --privileged -d $(IMAGE)

#Stop and remove the image
stop:
	docker stop jenkins-node-docker; \
	docker rm jenkins-node-docker

#Remove containers and dangling volumes and images
clean:
	-docker ps -a -q | xargs docker rm
	-docker volume ls --filter="dangling=true" | xargs docker volume rm
	-docker images --filter='dangling=true' -q | xargs docker rmi
