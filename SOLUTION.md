# Assessment Solution

## Explanation and Deliverable

To deliver a solution which can be deployed easily to any empty cloud
subscription I have chosen Docker and Docker-Compose as my desired tools. My
deliverable include:

* Dockerfile: This is used to create an image which can be easily leveraged for
  local development as well as cloud deployments.
* Docker compose yaml file: Used to lay out the containers and related details
  such as networks, volumes and ports. I am also leveraging docker compose to
  deploy to AWS ECS platform. 
* CI/CD pipeline via Travis-CI: The pipeline provides an automated way to build
  the code, create a Docker image and deploy to AWS environment.

### Changes to conf.toml

* Changes DbHost value to postgres and ListenHost value to 0.0.0.0
  
### Changes to Dockerfile

* Install missing go dependencies for go-swagger
* Updates `ENTRYPOINT` script to create, seed db and then serve the application

### Introduced Docker Compose

* Orchestrated `postgres` and `TechTestApp` deployments via docker-compose
* Adds `postgres` as dependency of `TechTestApp`
* Adds them to a user-defined bridge network to ensure better isolation and
  interoperability between containerized applications.

### CI/CD via Travis-CI

An automated CI/CD pipeline is created to build the source code, create and
push the docker images to docker hub and subsequently pull them via ecs-cli to
deploy to AWS ECS service.

The pipeline has the following 3 stages:

1. Build source code using `build.sh` and simply test the generated binary
2. Build and push docker image to Docker Hub
3. Deploy to AWS ECS service leveraging the image from Docker Hub published in
   previous step using `ecs-cli`.

## Other important Links:

* Docker-hub url: [https://hub.docker.com/repository/docker/abybhamra/techtestapp]
* Final hosted solution url: [http://ec2-54-190-134-5.us-west-2.compute.amazonaws.com]
  and swagger url: [http://ec2-54-190-134-5.us-west-2.compute.amazonaws.com/swagger/]
* Travis Build: [https://travis-ci.org/abybhamra/TechTestApp/]

