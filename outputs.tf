output "out-region" {
  value = var.region
}

output "vpc-azs" {
    value = element(data.aws_availability_zones.k8s-vpc-azs.names, 0)
}
