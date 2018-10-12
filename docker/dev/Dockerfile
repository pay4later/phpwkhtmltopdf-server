FROM php:5.6.37-cli

LABEL org.label-schema.schema-version="1.0" \
    org.label-schema.name="Build Container for Web Server HTML to PDF Renderer" \
    org.label-schema.description="PHP CLI for installing dependencies and running tests" \
    org.label-schema.url="https://github.com/pay4later/phpwkhtmltopdf-server"

RUN apt-get update -q \
    && apt-get install -y \
        zlib1g-dev \
        git \
    && docker-php-ext-install \
        zip \
    && rm -rf /var/lib/apt/lists/*
