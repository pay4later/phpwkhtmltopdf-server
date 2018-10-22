FROM docker.deko-dev.com/phpwkhtmltopdf-server/base:5.6.38-apache-0.1.0

LABEL org.label-schema.schema-version="1.0" \
    org.label-schema.name="Web Server HTML to PDF Renderer" \
    org.label-schema.description="Uses PHP and Apache to receive HTML in a POST request and return a binary PDF" \
    org.label-schema.url="https://github.com/pay4later/phpwkhtmltopdf-server"

COPY ./docker/apache-vhost.conf /etc/apache2/sites-available/000-default.conf
COPY ./docker/php.ini /usr/local/etc/php/conf.d/90-php.ini
COPY . /opt/phpwkhtmltopdf-server

WORKDIR /opt/phpwkhtmltopdf-server
