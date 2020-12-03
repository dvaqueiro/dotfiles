# Very Basic Docker intro:
---

## Check docker
* `docker version`
* `ps aux | grep docker`

## Work with containers
* `docker run <image_name>` Build and run a container from an image.
    > * Example: docker run hello-world
    > * Concept: Image. Single file with all deps and configs to run a command.
    > * Concept: Container. Instance of image.
    > * Concept: Registry. Repository contains images to pull/push. (Private or public).

* `docker run <image_name> command` Build and run a container overwriting image command.
    > * Example: docker run busybox echo hello world
    > * Example: docker run busybox ping google.com

* `docker ps` List running containers.
* `docker ps -a` List all containers containers.

## Container lifecycle
* `docker create <image_name>` Create a container from a image.
    > * Example: docker create hello-world

* `docker start <container_id>` Start a container.
    > * Example: docker start -a 434232432
    > * *Tip: docker run = docker create + docker start*

## More containers stuff
* `docker rm <container_id>` Remove a stopped container.
* `docker logs <container_id>` Fetch container logs.
* `docker logs -f <container_id>` Fetch and follow container logs until Ctrl-c.
* `docker stop <container_id>` Stop a running container gracefull.
* `docker kill <container_id>` Stop a container killing process.
* `docker exec -it <container_id> <command>` Execute additional command in a container.
    > * *-i		Keep STDIN open even if not attached*
    > * *-t		Allocate a pseudo-TTY*
    > * Concept: Container isolation.

## Advanced run container
* `docker run --name loca-mysql5.7 -e MYSQL_ROOT_PASSWORD=root -d mysql:5.7`
    > * *-d	    Detach from execution*
    > * *--name Set container name*
    > * *-e     Pass environment variable to container*

* `docker run --name mysql_57 -p 3307:3306 -e MYSQL_ROOT_PASSWORD=root -d mysql:5.7`

## Build your own custom images
...

