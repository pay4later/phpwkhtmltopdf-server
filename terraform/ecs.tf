data "aws_ami" "latest_ecs_optimised" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-2018.03.g-amazon-ecs-optimized"]
  }
}

resource "aws_ecs_cluster" "cluster" {
  name  = "${local.namespace}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "ecs_instance" {
  name_prefix                 = "${local.namespace}-"
  image_id                    = "${data.aws_ami.latest_ecs_optimised.image_id}"
  instance_type               = "${var.ecs_instance_type}"
  security_groups             = ["${aws_security_group.ecs_instance.id}"]
  iam_instance_profile        = "${aws_iam_instance_profile.ecs_instance.name}"
  key_name                    = "${var.ssh_key_name}"
  associate_public_ip_address = false

  user_data = <<EOF
#!/bin/bash
echo ECS_CLUSTER=${aws_ecs_cluster.cluster.name} >> /etc/ecs/ecs.config
EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "ecs_instance" {
  description = "Allows all outbound traffic"
  vpc_id      = "${var.vpc_name}"

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    self        = true
    description = "Ephemeral port range"
  }

  ingress {
    from_port   = 32768
    to_port     = 65535
    protocol    = "tcp"
    self        = true
    description = "Ephemeral port range"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${data.aws_vpc.vpc.cidr_block}"]
    description = "SSH from VPC"
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    description      = "Allow all outbound traffic"
  }

  lifecycle {
    create_before_destroy = true
  }
}
