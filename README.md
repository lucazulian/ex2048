# Ex2048

A multiplayer version of 2048 game with Phoenix Liveview

[![CI](https://github.com/lucazulian/ex2048/actions/workflows/ci.yml/badge.svg)](https://github.com/lucazulian/ex2048/actions/workflows/ci.yml)


## About the Application

TODO


## Getting started
 
### Local environment

In your local environment it needs to install all **Requirements** beforehand.

#### Gets all dependencies

```bash
mix deps.get
```

#### Setup application

```bash
mix setup
```

#### Start application

```bash
mix phx.server
```


### Docker Compose

Docker Compose is used to simplify development and configuration.
Makefile is used as a wrapper around docker-compose commands.
Some commands are aliases around mix aliases, just to avoid boring and repetitive commands. 

#### Make commands

```bash
build                          Build all containers
delete                         Delete all containers, images and volumes
halt                           Shoutdown all containers
setup                          Setup application
shell                          Enter into game container
start                          Start application
up                             Start all containers
```

#### Setup the application

```bash
make setup
```

#### Start the application

```bash
make start
```

#### Destroy environment

```bash
make delete
```

## Assumptions

  - TODO

## Improvements / Missing parts

  - TODO
