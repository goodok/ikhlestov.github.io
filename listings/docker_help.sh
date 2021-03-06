# based on this tutorial https://docs.docker.com/engine/userguide/containers/dockerizing/
# list running images
$ docker ps
# list all containers
$ docker ps -a
# stop the container
$ docker stop CONTAINER ID 
# remove a container
$ docker rm CONTAINER ID 
# list all images
$ docker images
# remove image
$ docker rmi IMAGE ID 
# create a build from Dockerfile
$ docker build -t ikhlestov/thenotes-docker .
# run image and enter to it
$ docker run -t -i ouruser/sinatra:v2 /bin/bash
# run image with name
$ docker run -d -P --name web training/webapp python app.py
# login to docker on the AWS EC2 service
$ $(aws ecr get-login --region us-west-2)
# attach to already running container
$ docker start -ai container_name
# mount some folder inside docker container on the start
$ docker run -it -v /path/from:/path/to /bin/bash
# run some web image
$ docker run -it -d some.uri.amazonaws.com/mxnet:gpu /bin/bash
# check the state of container by name
$ docker inspect web
# list all networks drivers
$ docker network ls
# again run an image
$ docker run -itd --name=networktest ubuntu
# inspect current sate of network
$ docker network inspect bridge
# disconnect a container
$ docker network disconnect bridge networktest
# enter inside running container
$ docker exec -it CONTAINER_NAME bash
# remove the container and its image after exit
$ docker run --rm CONTAINER_NAME
# Deploying changes
$ docker-compose build web
$ docker-compose up --no-deps -d web
# run with additional settings file and in background
$ docker-compose -f docker-compose.yml -f production.yml up -d
# enter to compose container
$ docker-compose run CONTAINER_NAME bash
# stop first running docker instance
# all runing| second line| container name    | stop container by name
$ docker ps | sed -n 2p  | awk '{print $NF}' | xargs docker stop
# stop all running containers
$ docker ps | awk '{print $NF}' | tail -n +2 | xargs docker stop
# connect to already runnning container
$ docker start -ai CONTAINER_NAME
