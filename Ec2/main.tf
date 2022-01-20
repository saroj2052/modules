resource "aws_instance" "web" {
  count =var.count_num
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id = element(var.subnet_id, count.index) 
  security_groups = var.securitygroup

  tags = {
    Name = "HelloWorld-${count.index}"
  }
}