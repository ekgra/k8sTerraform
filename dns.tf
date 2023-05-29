# data "aws_route53_zone" "selected" {
#   name         = "mdbrecruit.net."
#   private_zone = false
# }


# resource "aws_route53_record" "k8s-master-dns-private" {
#   zone_id = data.aws_route53_zone.selected.zone_id
#   name    = var.k8s-master-hostname
#   type    = "A"
#   ttl     = "300"
#   records = [aws_instance.k8s-master.private_ip]
#   depends_on = [aws_instance.k8s-master]
# }

# resource "aws_route53_record" "k8s-worker-1-dns-private" {
#   zone_id = data.aws_route53_zone.selected.zone_id
#   name    = var.k8s-worker-1-hostname
#   type    = "A"
#   ttl     = "300"
#   records = [aws_instance.k8s-worker-1.private_ip]
#   depends_on = [aws_instance.k8s-worker-1]
# }

# resource "aws_route53_record" "k8s-worker-2-dns-private" {
#   zone_id = data.aws_route53_zone.selected.zone_id
#   name    = var.k8s-worker-2-hostname
#   type    = "A"
#   ttl     = "300"
#   records = [aws_instance.k8s-worker-2.private_ip]
#   depends_on = [aws_instance.k8s-worker-2]
# }