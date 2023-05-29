output "out-region" {
  value = var.region
}

output "vpc-azs" {
  value = element(data.aws_availability_zones.k8s-vpc-azs.names, 0)
}

# https://github.com/terraform-aws-modules/terraform-aws-ec2-instance/blob/master/outputs.tf
output "public_ip" {
  description = "The public IP address assigned to the instance, if applicable. NOTE: If you are using an aws_eip with your instance, you should refer to the EIP's address directly and not use `public_ip` as this field will change after the EIP is attached"
  value = [
    aws_instance.k8s-node[0].public_ip,
    aws_instance.k8s-node[1].public_ip,
    aws_instance.k8s-node[2].public_ip
  ]
}

output "private_ip" {
  description = "The private IP address assigned to the instance"
  value = [
    aws_instance.k8s-node[0].private_ip,
    aws_instance.k8s-node[1].private_ip,
    aws_instance.k8s-node[2].private_ip
  ]
}