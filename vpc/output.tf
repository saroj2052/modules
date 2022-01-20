output "vpc_id" {
  value = aws_vpc.vpc.id
}
output "pub_subnet" {
    description = "subnet public id list"
    #for list 
  value = [for subnet in aws_subnet.aws_pub_subnet: subnet.id]

}