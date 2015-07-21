# pay4later/phpwkhtmltopdf-server

A web front-end to pass POST requests to wkhtmltopdf and return a downloadable PDF.

## Requirements

- PHP >= 5.4
- wkhtmltopdf >= 0.12
- *nix based OS - Windows may work but is not tested

## Installation

```sh
composer install
cd config/
cp local.php.dist local.php
vim local.php
```

## Usage

Start a php web server in the public directory if required: `php -S localhost:8080 -t public/`.

@TODO see the [examples/](blob/master/examples) directory for supported POST formats.

## Limitations

Authentication is not supported at this point and only basic error reporting is implemented. Consumers must
rely on the HTTP Status Code of the response header to verify their request was successful. 