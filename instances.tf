# data "aws_ssm_parameter" "ubuntu-ami" {
#   provider = aws.provider
#   name     = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20230517"
# }

# data "aws_key_pair" "sydneyKeyPair" {
#   provider           = aws.region_master
#   key_name           = "sydneyKeyPair"
#   include_public_key = true
# }

# resource "aws_key_pair" "ec2_key_pair_worker" {
#   provider   = aws.region_worker
#   key_name   = "testSSHKey"
#   public_key = file("/Users/outlander/.ssh/testSSHKey.pub")
# }

# resource "aws_instance" "ec2_jenkins_master" {
#   provider                    = aws.region_master
#   ami                         = data.aws_ssm_parameter.ami_master.value
#   instance_type               = var.instance_type
#   key_name                    = data.aws_key_pair.ec2_key_pair_master.key_name
#   associate_public_ip_address = true
#   vpc_security_group_ids      = [aws_security_group.sg_jenkins_master.id]
#   subnet_id                   = aws_subnet.subnet_master_1.id
#   tags = {
#     Name = "jenkins-master-tf"
#   }
#   depends_on = [aws_main_route_table_association.set_rtbl_assoc_main_master]
# }

# resource "aws_instance" "ec2_jenkins_worker" {
#   provider                    = aws.region_worker
#   count                       = var.worker_count
#   ami                         = data.aws_ssm_parameter.ami_worker.value
#   instance_type               = var.instance_type
#   key_name                    = aws_key_pair.ec2_key_pair_worker.key_name
#   vpc_security_group_ids      = [aws_security_group.sg_jenkins_worker.id]
#   associate_public_ip_address = true
#   subnet_id                   = aws_subnet.subnet_worker_1.id
#   tags = {
#     Name = join("-", ["jenkins-worker-tf", count.index + 1])
#   }
#   depends_on = [aws_main_route_table_association.set_rtbl_assoc_main_worker, aws_instance.ec2_jenkins_master]
# }