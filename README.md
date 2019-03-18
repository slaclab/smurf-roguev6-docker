# Docker image with Rogue for the SMuRF project

## Description

This docker image, named **smurf-rogue** contains Rogue and additional tools used by the SMuRF project.

It is based on the **smurf-base** docker image and contains Rogue.

## Source code

Rogue source code is checked out for the SLAC's github repository https://github.com/slaclab/rogue.

## Building the image

When a tag is pushed to this github repository, a new Docker image is automatically built and push to its [Dockerhub repository](https://hub.docker.com/r/tidair/smurf-rogue) using travis.

The resulting docker image is tagged with the same git tag string (as returned by `git describe --tags --always`).

## Using the container

The image is intended mainly to be use as a base to build other docker images. In order to do so, start the new docker image Dockerfile with this line:

```
ROM tidair/smurf-rogue:<TAG>
```

A container however can be run as well from this image. For example, you can start the container in the foreground with this command

```
docker run -ti --rm --name smurf-rogue tidair/smurf-rogue:<TAG>
```

Where:
- **<TAG>**: is the tagged version of the container your want to run.