variable vpc_name {
  description = "ID of existing VPC to use"
}

variable cluster_name {
  description = "Name of existing cluster to register service with"
}

variable ecs_instance_security_group_id {
  description = "ID of the clusters security group so associate with the load balancer"
}

variable "route53_zone_name" {
  description = "The DNS zone that var.domain is to be provisioned within"
}

variable "domain" {
  description = "The FQDN to point at the load balancer"
}

variable "region" {
  description = "The AWS region to provision resources in"
}

variable "docker_image" {
  description = "The image to use for the ECS Task Definition."
}

variable min_task_count {
  description = "Minimum number tasks that should be running in cluster"
}

variable max_task_count {
  description = "Maximum number of tasks that should be running in cluster"
}

variable "acm_certificate_domain" {
  description = "Find the load balancer certifcate by domain name"
}

// Scaling options
variable "scale-up-cooldown" {
  type        = "string"
  description = "Cooldown when scaling up the Apache workers"
  default     = "60"
}

variable "scale-down-cooldown" {
  type        = "string"
  description = "Cooldown when scaling down the Apache workers"
  default     = "120"
}

variable "cpu-high-threshold" {
  type        = "string"
  description = "Threshold when CloudWatch reports high CPU usage"
  default     = "90"
}

variable "cpu-high-period" {
  type        = "string"
  description = "Period when CloudWatch checks for high CPU usage"
  default     = "60"
}

variable "cpu-low-threshold" {
  type        = "string"
  description = "Threshold when CloudWatch reports low CPU usage"
  default     = "20"
}

variable "cpu-low-period" {
  type        = "string"
  description = "Period when CloudWatch checks for low CPU usage"
  default     = "60"
}

variable "task_memory_reservation" {
  description = "Soft memory reservation for ECS container in MB"
}

variable "task_cpu" {
  description = "Soft CPU reservation for ECS container in CPU units (1024 = 1 cpu)"
}

locals {
  project   = "pdf-renderer"
  namespace = "${terraform.workspace}-${local.project}"

  common_tags = {
    Environment = "${terraform.workspace}"
    Project     = "${local.project}"
  }
}
