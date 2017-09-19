#
# This Dockerfile creates a Jenkins build-node for running build jobs that require docker.
#
FROM docker.io/docker:17.06-dind
MAINTAINER Chandra Sekhar Eswa <e.chandrasekhar@gmail.com>


# Install and setup packages that Jenkins needs. Rename docker so it can be replaced by a wrapper
RUN apk add --no-cache openssh && \
    apk add --no-cache openjdk8 && \
    apk add --no-cache bash && \
    apk add --no-cache git && \
    rm -rf /var/cache/apk/* && \
    /usr/bin/ssh-keygen -A && \
    mv /usr/local/bin/docker /usr/local/bin/docker_orig

# Create jenkins user and docker group.
RUN addgroup docker && \
    adduser jenkins -h /home/jenkins -s /bin/bash -G docker -D && \
    echo "jenkins:jenkins" | chpasswd

# Install additional software for applications.
RUN apk add --no-cache jq

# Copy docker wrapper to location which is in Jenkins-defined path. Wrapper is needed
# to force docker to use localhost as host instead of DOCKER_HOST that Jenkins defines.
COPY ./scripts/docker-wrapper.sh /usr/bin/docker

# Use the modified entrypoint
COPY ./scripts/dockerd-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["dockerd-entrypoint.sh"]

EXPOSE 22

CMD []
