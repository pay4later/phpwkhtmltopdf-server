data "aws_iam_role" "ecs_service_role" {
  name = "ecsServiceRole"
}

locals {
  container_name = "${local.project}"
}

resource "aws_ecs_service" "apache_service" {
  name            = "${local.namespace}"
  cluster         = "${aws_ecs_cluster.cluster.id}"
  task_definition = "${aws_ecs_task_definition.apache_service.arn}"
  iam_role        = "${data.aws_iam_role.ecs_service_role.arn}"

  load_balancer {
    target_group_arn = "${aws_alb_target_group.apache_service_target_group.arn}"
    container_name   = "${local.container_name}"
    container_port   = "80"
  }

  depends_on      = [
    "aws_alb_listener.apache_service"
  ]
}

resource "aws_ecs_task_definition" "apache_service" {
  family        = "${local.namespace}"
  container_definitions = <<EOF
[

    {
      "portMappings": [
        {
          "hostPort": 0,
          "containerPort": 80
        }
      ],
      "cpu": ${var.task_cpu},
      "memoryReservation": ${var.task_memory_reservation},
      "image": "${var.docker_image}",
      "essential": true,
      "name": "${local.container_name}"
    }
]
EOF
}

data "aws_acm_certificate" "web" {
  domain   = "${var.acm_certificate_domain}"
  statuses = ["ISSUED"]
}

resource "aws_alb_listener" "apache_service" {
  load_balancer_arn = "${aws_alb.web.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = "${data.aws_acm_certificate.web.arn}"

  default_action {
    target_group_arn = "${aws_alb_target_group.apache_service_target_group.arn}"
    type             = "forward"
  }
}

resource "aws_alb_target_group" "apache_service_target_group" {
  name = "${local.namespace}"
  port     = "80"
  protocol = "HTTP"
  vpc_id   = "${data.aws_vpc.vpc.id}"

  tags  = "${local.common_tags}"

  health_check {
    path                = "/healthcheck.html"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on      = [
    "aws_alb.web"
  ]
}
