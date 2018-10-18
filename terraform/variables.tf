variable vpc_name {
  description = "ID of existing VPC to use"
}

variable "route53_zone_name" {
  default = ""
}

variable "domain" {
  default = ""
}

variable "region" {
  description = "The AWS region to provision resources in"
}

variable "docker_image" {
  description = "The image to use for the ECS Task Definition."
}

variable ecs_instance_type {
  default = "t2.small"
}

variable min_ec2_instances {
  description = "Minimum umber of EC2 instances that should be running in cluster"
}

variable max_ec2_instances {
  description = "Maximum number of EC2 instances that should be running in cluster"
}

variable min_task_count {
  description = "Minimum number tasks that should be running in cluster"
}

variable max_task_count {
  description = "Maximum number of tasks that should be running in cluster"
}

variable ssh_key_name {
  description = "Name of an existing SSH key for the EC2 instances in the cluster"
}

variable desired_pdf_service_count {
  description = "desired number of running PDF service tasks"
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

locals {
  project   = "pdf-renderer"
  namespace = "${terraform.workspace}-${local.project}"

  common_tags = {
    Environment = "${terraform.workspace}"
    Project     = "${local.project}"
  }
}
