# User data script for management instance
data "template_file" "management_user_data" {
  template = <<-EOF
#!/bin/bash
sudo yum update -y
sudo yum install -y openssh-server
sudo systemctl start sshd
sudo systemctl enable sshd
EOF
}

# Management EC2 Instance
resource "aws_instance" "management" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  subnet_id     = var.management_subnet
  security_groups = [var.management_sg_id]

  user_data = base64encode(data.template_file.management_user_data.rendered)

  tags = {
    Name = "management-instance"
  }
}

# AMI Data Source
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}