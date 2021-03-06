#!/bin/bash

TERRAFORM_VERSION="0.11.10"

docker run --rm \
    -v $(pwd)/terraform:/opt/phpwkhtmltopdf-server/ -w /opt/phpwkhtmltopdf-server/ \
    -v ~/.aws:/.aws/ \
    -e AWS_PROFILE \
    -e AWS_ACCESS_KEY_ID \
    -e AWS_SECRET_ACCESS_KEY \
    -e AWS_SESSION_TOKEN \
    -u $(id -u) \
    hashicorp/terraform:$TERRAFORM_VERSION $@
