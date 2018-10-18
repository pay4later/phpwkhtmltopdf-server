data "aws_iam_role" "ecs_service_role" {
  name = "ecsServiceRole"
}

resource "aws_ecs_service" "pdf_service" {
  name            = "${local.namespace}"
  cluster         = "${aws_ecs_cluster.cluster.id}"
  task_definition = "${aws_ecs_task_definition.pdf_service.arn}"
  desired_count   = "${var.desired_pdf_service_count}"
  iam_role        = "${data.aws_iam_role.ecs_service_role.arn}"

  load_balancer {
    target_group_arn = "${aws_alb_target_group.pdf_service_target_group.arn}"
    container_name   = "${local.namespace}"
    container_port   = "80"
  }
}

resource "aws_ecs_task_definition" "pdf_service" {
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
      "cpu": 500,
      "memory": 512,
      "memoryReservation": null,
      "image": "${var.docker_image}",
      "essential": true,
      "name": "${local.namespace}"
    }
]
EOF
}

data "aws_acm_certificate" "web" {
  domain   = "${var.acm_certificate_domain}"
  statuses = ["ISSUED"]
}

resource "aws_alb_listener" "pdf_service" {
  load_balancer_arn = "${aws_alb.web.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = "${data.aws_acm_certificate.web.arn}"
  depends_on      = [
    "aws_alb.web"
  ]

  default_action {
    target_group_arn = "${aws_alb_target_group.pdf_service_target_group.arn}"
    type             = "forward"
  }
}

resource "aws_alb_target_group" "pdf_service_target_group" {
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
