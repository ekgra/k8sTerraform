variable "region" {
  type    = string
  default = "ap-southeast-2"
}

variable "vpc-name" {
  type    = string
  default = "k8s-vpc"
}

variable "instance-type" {
  type    = string
  default = "t3.medium"
}

# variable "k8s-master-hostname" {
#   type    = string
#   default = "k8s-master.mdbrecruit.net"
# }

# variable "k8s-worker-1-hostname" {
#   type    = string
#   default = "k8s-worker-1.mdbrecruit.net"
# }

# variable "k8s-worker-2-hostname" {
#   type    = string
#   default = "k8s-worker-2.mdbrecruit.net"
# }