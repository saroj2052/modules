
data "aws_availability_zones" "myaz" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}
# data "aws_ec2_instance_type_offerings" "az_ins_typ2" {
#   for_each = toset(data.aws_availability_zones.myaz.names)
#   filter {
#     name   = "instance-type"
#     values = ["t3.micro"]
#   }

#   filter {
#     name   = "location"
#     values = [each.key]
#   }

#   location_type = "availability-zone"
# }