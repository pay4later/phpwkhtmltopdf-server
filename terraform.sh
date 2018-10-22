#!/bin/bash

TERRAFORM_VERSION="0.11.7"

docker run --rm \
    -v $(pwd)/terraform:/app/ -w /app/ \
    -v ~/.aws:/.aws/ \
    -e AWS_PROFILE \
    -e AWS_ACCESS_KEY_ID \
    -e AWS_SECRET_ACCESS_KEY \
    -e AWS_SESSION_TOKEN \
    -u $(id -u) \
    hashicorp/terraform:$TERRAFORM_VERSION $@
