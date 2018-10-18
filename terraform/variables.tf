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

variable ssh_key_name {
  description = "Name of an existing SSH key for the EC2 instances in the cluster"
}

variable desired_pdf_service_count {
  description = "desired number of running PDF service tasks"
}

variable "acm_certificate_domain" {
  description = "Find the load balancer certifcate by domain name"
}

locals {
  project   = "pdf-renderer"
  namespace = "${terraform.workspace}-${local.project}"

  common_tags = {
    Environment = "${terraform.workspace}"
    Project     = "${local.project}"
  }
}
