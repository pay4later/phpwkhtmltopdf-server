DEFAULT_GOAL: init
USER_ID=$(shell id -u)
GROUP_ID=$(shell id -g)

## Initializes the application
init: composer.phar
	php composer.phar install

## Installs dependencies for production
prod: composer.phar
	php composer.phar install --no-dev --no-interaction --no-progress --optimize-autoloader

## Initializes the application using docker
docker-init: docker-login
	cp .env.example .env
	docker-compose build
	docker-compose run --rm -u $(USER_ID):$(GROUP_ID) dev make init

## Installs composer locally
composer.phar:
	curl -sS https://getcomposer.org/installer | php

## Login to our private docker repo
docker-login:
	docker login -u docker-readonly -p docker-readonly docker.deko-dev.com

## Build the base container
docker-base:
	./bin/docker-build-base docker/base phpwkhtmltopdf-server/base 5.6.38-apache

## Build the dev container
docker-dev:
	./bin/docker-build-base docker/dev phpwkhtmltopdf-server/dev 5.6.38-cli

## Run tests
test:
	vendor/bin/phpunit

## Run tests
docker-test:
	docker-compose run --rm -u $(USER_ID):$(GROUP_ID) dev make test
