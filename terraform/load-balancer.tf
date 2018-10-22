resource "aws_alb" "web" {
  name            = "${local.namespace}"
  internal        = false
  security_groups = [
    "${aws_security_group.load-balancer.id}",
    "${aws_security_group.ecs_instance.id}",
  ]
  subnets         = ["${data.aws_subnet_ids.public.ids}"]
  tags            = "${local.common_tags}"
  idle_timeout    = 300
}

resource "aws_security_group" "load-balancer" {
  name        = "${local.namespace}"
  description = "Allows inbound web traffic"
  vpc_id      = "${var.vpc_name}"
  tags            = "${local.common_tags}"

  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
