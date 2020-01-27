# Assessment Solution

[![Build Status](https://travis-ci.org/abybhamra/TechTestApp.svg?branch=master)](https://travis-ci.org/abybhamra/TechTestApp)

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

1. **Changes to conf.toml**

    * Changes DbHost value to postgres and ListenHost value to 0.0.0.0
  
2. **Changes to Dockerfile**

    * Install missing go dependencies for go-swagger
    * Updates `ENTRYPOINT` script to create, seed db and then serve the application

3. **Introduced Docker Compose**

    * Orchestrated `postgres` and `TechTestApp` deployments via docker-compose
    * Adds `postgres` as dependency of `TechTestApp`
    * Adds them to a user-defined bridge network to ensure better isolation and
      interoperability between containerized applications.

4. **CI/CD via Travis-CI** 

    An automated CI/CD pipeline is created to build the source code, create and
    push the docker images to docker hub and subsequently pull them via ecs-cli to
    deploy to AWS ECS service.
    
    The pipeline has the following 3 stages:
    
    1. Build source code using `build.sh` and simply test the generated binary
    2. Build and push docker image to Docker Hub
    3. Deploy to AWS ECS service leveraging the image from Docker Hub published in
       previous step using `ecs-cli`.

## Running Solution

### Pre-requisites

* Docker
* Docker Compose

### Running Solution Locally

* Environment variables
    ```shell script
    export VTT_DBNAME=<value>
    export VTT_DBUSER=<value>
    export VTT_DBPASSWORD=<value>
    ```

* Docker Compose
    ```shell script
    docker-compose up
    ```

## Assessment Consideration Criteria

1. **Coding Style**

    The automation leveraging docker, docker-compose and travis focuses on
    12-factor application. Below is explanation of how some of the principles
    were respected:
    
    1. Config: Leverage env-variables via Jenkins file to create the public cloud
       env over checking-in the `DbName`, `DbUser`, and `DbPassword` in
       `config.toml`.
    2. Dependencies: Dependencies extracted & called out in docker-compose and
       isolated.
    3. Build, release, run: The process separates out build, release stages. The
       pipeline builds the code followed by docker image and pushes to Docker Hub.
       A separate stage take care of pulling the image and pushing to AWS ECS 
       service.
    4. Dev/prod parity: In developer machine I was leveraging `docker-compose.yml`
       with my `docker-compose` CLI. Whereas in the prod environment I used the same
       `docker-compose.yml` with AWS `ecs-cli`.

2. **Security**
    
    1. User-defined bridge network
    2. Injection of credentials from build process via env-vars

3. **Simplicity**
    
    1. No environment hacks required. No superfluous dependency which is different
       for dev and prod 

4. **Resiliency**

    1. Resiliency was tested by scaling in cloud provider leveraging scaling provided.
       For AWS ECS solution we used the following commands:
       
       ```shell script
       ecs-cli scale --size 2 # Scales the AWS ECS containers in a cluster to 2
       compose --file docker-compose.yml scale 2 # Scales the AWS ECS tasks running on containers. These tasks run the docker containers
       ```

## Notes:

All AWS testing done is to ensure the solution works on cloud environment via
CI/CD pipeline. Servian would not need to access any of my cloud environment
for testing. Servian team can directly use my public docker image
([link](https://hub.docker.com/repository/docker/abybhamra/techtestapp))
and checked-in `docker-compose.yml` to perform testing on their machines or
desired public cloud.

## Other important Links:

* Docker-hub url: [https://hub.docker.com/repository/docker/abybhamra/techtestapp]
* Final hosted solution url: [http://ec2-34-220-60-211.us-west-2.compute.amazonaws.com]
  and swagger url: [http://ec2-34-220-60-211.us-west-2.compute.amazonaws.com/swagger/]
* Travis Build: [https://travis-ci.org/abybhamra/TechTestApp/]

