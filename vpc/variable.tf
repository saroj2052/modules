variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"

}
variable "loc" {
    type = string
    default = "dev"
  
}

variable "subnet_count" {
  type    = number
  default = 2

}
variable "aws_subnets" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

}