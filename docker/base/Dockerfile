FROM php:5.6.38-apache-stretch

LABEL org.label-schema.schema-version="1.0" \
    org.label-schema.name="Base Container for Web Server HTML to PDF Renderer" \
    org.label-schema.description="Add source code" \
    org.label-schema.url="https://github.com/pay4later/phpwkhtmltopdf-server"

EXPOSE 80

ENV BUILD_PACKAGES build-essential wget
ENV MAIN_PACKAGES  fontconfig libjpeg62-turbo libssl1.1 libxext6 libxrender-dev xfonts-base xfonts-75dpi libpng16-16

RUN apt-get update \
    && apt-get install --no-install-recommends -yq $BUILD_PACKAGES $MAIN_PACKAGES \
    && wget https://downloads.wkhtmltopdf.org/0.12/0.12.5/wkhtmltox_0.12.5-1.stretch_amd64.deb \
    && dpkg -i wkhtmltox_0.12.5-1.stretch_amd64.deb \
    && rm wkhtmltox_0.12.5-1.stretch_amd64.deb \
    && apt-get remove -y $BUILD_PACKAGES \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && truncate -s 0 /var/log/*log


