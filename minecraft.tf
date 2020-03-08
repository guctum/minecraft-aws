# Variables
variable "key_name" {}
variable "private_key_path" {}
variable "vpc_id" {}
variable "iam_instance_profile" {}
variable "security_group" {}

provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "minecraft" {
  ami = "ami-0e38b48473ea57778"
  instance_type = "t2.micro"
  key_name = var.key_name
  security_groups = [var.security_group]

  iam_instance_profile = var.iam_instance_profile

  connection {
    type = "ssh"
    host = self.public_ip
    user = "ec2-user"
    private_key = file(var.private_key_path)
  }

  tags = {
    Name = "Minecraft box"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update",
      "sudo yum install java-1.8.0",
      "mkdir minecraft",
      "cd minecraft",
      "wget https://launcher.mojang.com/v1/objects/bb2b6b1aefcd70dfd1892149ac3a215f6c636b07/server.jar"
      // TODO: see if we can edit the eula in here as well and maybe ops.json?
    ]
  }

}

// TODO: put the security group in here
