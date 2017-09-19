#!/bin/bash
# Wrapper for docker command to force it to use localhost as host. 
# This is needed until someone figures out how to over-write the DOCKER_HOST
# environment variable that Jenkins sets in the container.
#
set -- /usr/local/bin/docker_orig -H localhost "$@"
exec "$@"
