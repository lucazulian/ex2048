##
# Make utility to automate boring and repetitive commands
#
# @file Makefile
# @version 0.1

all: init

.NOTPARALLEL:
.PHONY: init setup start up build shell halt delete stats

exec-in-docker = docker-compose exec game

init: up setup

setup: up							## Setup application
	${exec-in-docker} mix setup

start: up							## Start application
	${exec-in-docker} mix serve

up:									## Start all containers
	docker-compose up -d --remove-orphans

build:								## Build all containers
	docker-compose build

shell: container-game				## Enter into game container
	${exec-in-docker} bash

halt:								## Shoutdown all containers
	docker-compose down

delete: halt						## Delete all containers, images and volumes
	@docker images -a | grep "game" | awk '{print $3}' | xargs docker rmi -f
	@docker ps -a | grep "game" | awk '{print $1}' | xargs docker rm -v

stats: up
	@docker stats

help:
	@echo "Usage: make [command]"
	@echo "Make utility to automate boring and repetitive commands."
	@echo
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo

container-%:
	@docker ps -q --no-trunc --filter status=running | grep $$(docker-compose ps -q $*) >/dev/null 2>&1 || docker-compose up -d $*

# end
