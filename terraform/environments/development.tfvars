vpc_name = "vpc-07349ae4f80b61842"
route53_zone_name = "deko-dev.com"
domain = "pdf.deko-dev.com"
ecs_instance_type = "t2.micro"
ssh_key_name = "master-development"
pdf_service_name = "pdf-service"
desired_pdf_service_count = 1
ec2_instances_desired_count = 1
min_ec2_instances = 1
max_ec2_instances = 2
acm_certificate_domain = "deko-dev.com"
region = "eu-west-2"
docker_image = "587025832112.dkr.ecr.eu-west-2.amazonaws.com/pdf-renderer:test3"
min_task_count = "1"
max_task_count = "2"