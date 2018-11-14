module "service-scaling" {
  source = "git::https://github.com/pay4later/terraform-ecs-service-scaling.git?ref=v0.2.1"

  name                        = "${local.namespace}-apache"
  services-min                = "${var.min_task_count}"
  services-max                = "${var.max_task_count}"
  ecs-cluster-name            = "${data.aws_ecs_cluster.cluster.cluster_name}"
  ecs-service-name            = "${aws_ecs_service.apache_service.name}"
  service-scale-up-cooldown   = "${var.scale-up-cooldown}"
  service-scale-down-cooldown = "${var.scale-down-cooldown}"
  service-cpu-high-period     = "${var.cpu-high-period}"
  service-cpu-high-threshold  = "${var.cpu-high-threshold}"
  service-cpu-low-period      = "${var.cpu-low-period}"
  service-cpu-low-threshold   = "${var.cpu-low-threshold}"
}
