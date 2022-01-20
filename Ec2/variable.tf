#   ami           = var.ami_id
#   instance_type = var.instance_type
#   subnet_id = var.subnet_id
#   security_groups = [var.securitygroup]

  variable "ami_id" {

    
  }
  variable "instance_type" {
      default = "t2.micro"
    
  }
  variable "subnet_id" {
      type = list(string)
    
  }
  variable "securitygroup" {
    type = set(string)
  }
  variable "count_num" {
    type = number
    default = 2
  }