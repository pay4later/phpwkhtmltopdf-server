vpc_name = "vpc-a69136c3"
route53_zone_name = "dekopay.com"
domain = "phpwkhtmltopdf-server.dekopay.com"
ecs_instance_type = "t3.small"
ssh_key_name = "master-eu-west-1"
min_ec2_instances = 1
max_ec2_instances = 2
acm_certificate_domain = "dekopay.com"
region = "eu-west-1"
docker_image = "587025832112.dkr.ecr.eu-west-2.amazonaws.com/pdf-renderer:test3"
min_task_count = 2
max_task_count = 4
task_cpu = 1000
task_memory_reservation = 1500
