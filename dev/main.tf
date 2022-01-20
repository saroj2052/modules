

module "vpc" {
    source = "../vpc"
  
}
module "sg" {
    source = "../securitygroup"
    vpc_id = "${module.vpc.vpc_id}"
  
}
module "ec2" {
    source = "../Ec2"
    ami_id         = "ami-08e4e35cccc6189f4"
#   instance_type = var.instance_type
    # count  = 2
    subnet_id = "${module.vpc.pub_subnet}"
    securitygroup = [module.sg.securitygroup_id]
  
}