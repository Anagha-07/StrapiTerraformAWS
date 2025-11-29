provider "aws" {
  region = var.aws_region
}

# ------- SECURITY GROUP -------
resource "aws_security_group" "strapi_sg" {
  name        = "strapi-sg"
  description = "Allow Strapi and SSH"

  ingress {
    from_port   = 1337
    to_port     = 1337
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ------- EC2 INSTANCE -------
resource "aws_instance" "strapi" {
  ami           = "ami-04b70fa74e45c3917"  # Ubuntu 24.04 LTS AMI in us-east-1
  instance_type = var.instance_type
  key_name      = var.key_name

  security_groups = [aws_security_group.strapi_sg.name]

  user_data = file("userdata.sh")

  tags = {
    Name = "strapi-server"
  }
}
