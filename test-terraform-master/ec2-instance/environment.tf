provider "aws" {
  region  = var.region
  profile = var.profile
}

resource "aws_instance" "terraform-ec2" {
  count = var.instance_count
  ami           = var.ami
  instance_type = var.int_type
  security_groups =var.sec_grp
  subnet_id =var.subnet
  key_name = var.key_pair

  tags = {
    Name = "${var.instance_name}-${count.index+1}"
  }
}