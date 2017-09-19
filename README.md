# Description
Jenkins build node for jobs that need to run docker commands. This project builds a docker image that can be used as build node in Jenkins master. The workflow is:
1. Build the image.
2. Push the image to docker registry.
3. Create the node in Jenkins master and set it to use the image from the registry.
4. Configure build jobs to use the new build node.

# Instructions

## Build

```
./build.sh
```

## Push to Docker registry

Set correct tag in push.sh script and

```
./push.sh
```
