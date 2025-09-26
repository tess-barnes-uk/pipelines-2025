# Docker: Helpful tips & references

- Base images can be found here: [https://hub.docker.com/](https://hub.docker.com/)
- Docker build documentation: [https://docs.docker.com/reference/cli/docker/build-legacy/](https://docs.docker.com/reference/cli/docker/build-legacy/)
- Docker run documentation: [https://docs.docker.com/reference/cli/docker/container/run/](https://docs.docker.com/reference/cli/docker/container/run/)
- Docker file syntax reference: [https://docs.docker.com/reference/dockerfile/](https://docs.docker.com/reference/dockerfile/) 

Building an image
For a basic build with a meaningful local tag, adapt this command to match the exercise
`docker build -t pipelines2025/{exercise}/{original|better} -f {filename} .`

e.g.
```shell
docker build -t pipelines2025/ex1/app -f Dockerfile. .
```

Listing your built images

```shell
docker images
docker images | grep pipelines2025/
```

Running up your images as containers

The basic command would be

```shell
docker run --name exercise2 --rm pipelines2025/ex1/app
```

However, different types of dockerfile & image may prompt more complex versions of commands

## Running docker on a mac

Due to licensing concerns with Docker Desktop (it's no longer for commercial use without a paid user account) it's worth looking into alternatives. [Rancher desktop](https://rancherdesktop.io/) can be installed using Kandji and will be kept up to date with Kandji controlled updates (where available). It is command-line heavy but we will be working with the docker cli for this course anyway.
