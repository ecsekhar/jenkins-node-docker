#!/bin/sh
# This is a modified version of original docker dockerd-entrypoint.sh. The additions
# to the original are these:
# 1. Start sshd which is required by Jenkins to run this container as a build node.
# 2. Remove parameters if '/usr/sbin/sshd' command was provided. This is the default
# command Jenkins sends to the container and would prevent docker to be started.

set -e

# Clear parameters
set --

# Start sshd
/usr/sbin/sshd -D -e &

# no arguments passed
# or first arg is `-f` or `--some-option`
if [ "$#" -eq 0 -o "${1#-}" != "$1" ]; then
        # add our default arguments
        set -- dockerd \
                --host=unix:///var/run/docker.sock \
                --host=tcp://0.0.0.0:2375 \
                --storage-driver=overlay2
                "$@"
fi

if [ "$1" = 'dockerd' ]; then
        # if we're running Docker, let's pipe through dind
        # (and we'll run dind explicitly with "sh" since its shebang is /bin/bash)
        set -- sh "$(which dind)" "$@"
fi

exec "$@"
