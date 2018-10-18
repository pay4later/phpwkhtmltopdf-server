data "aws_route53_zone" "zone" {
  name = "${var.route53_zone_name}"
}


resource "aws_route53_record" "alb" {
  zone_id = "${data.aws_route53_zone.zone.zone_id}"
  name    = "${var.domain}"
  type    = "A"

  alias {
    name                   = "${aws_alb.web.dns_name}"
    zone_id                = "${aws_alb.web.zone_id}"
    evaluate_target_health = false
  }
}
