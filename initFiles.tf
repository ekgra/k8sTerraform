# data "template_file" "init-master" {
#   template = "${file("init-master.sh")}"

#   vars = {
#     hostName = "${var.k8s-master-hostname}"
#   }
# }

# data "template_file" "init-worker-1" {
#   template = "${file("init-worker-1.sh")}"

#   vars = {
#     hostName = "${var.k8s-worker-1-hostname}"
#   }
# }

# data "template_file" "init-worker-2" {
#   template = "${file("init-worker-2.sh")}"

#   vars = {
#     hostName = "${var.k8s-worker-2-hostname}"
#   }
# }