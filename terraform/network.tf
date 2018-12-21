data "aws_vpc" "vpc" {
  id = "${var.vpc_name}"
}

data "aws_subnet_ids" "private" {
  vpc_id = "${var.vpc_name}"

  tags {
    Tier = "private"
  }
}

data "aws_subnet_ids" "public" {
  vpc_id = "${var.vpc_name}"

  tags {
    Tier = "public"
  }
}
