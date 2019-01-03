data "aws_elb_service_account" "main" {}

locals {
  access_logs_bucket_name = "deko-${local.namespace}-access-logs"
}

resource "aws_s3_bucket" "access_logs" {
  bucket = "${local.access_logs_bucket_name}"
  acl    = "log-delivery-write"
  tags   = "${local.common_tags}"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle_rule {
    id      = "expire"
    enabled = true
    tags    = "${local.common_tags}"

    expiration {
      days = 90
    }
  }

  policy = <<EOF
{
  "Id": "Policy1517840189063",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${local.access_logs_bucket_name}/web/*",
      "Principal": {
        "AWS": [
          "${data.aws_elb_service_account.main.arn}"
        ]
      }
    }
  ]
}
EOF
}

data "aws_lambda_function" "ship_logs" {
  function_name = "DatadogShipLogs"
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = "${aws_s3_bucket.access_logs.id}"

  lambda_function {
    lambda_function_arn = "${data.aws_lambda_function.ship_logs.id}"
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "AWSLogs/"
    filter_suffix       = ".log"
  }
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = "${data.aws_lambda_function.ship_logs.id}"
  principal     = "s3.amazonaws.com"
  source_arn    = "${aws_s3_bucket.access_logs.arn}"
}

