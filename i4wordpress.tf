provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet" "default_az1" {
  availability_zone = "us-east-2a"
}


resource "aws_security_group" "web_sg" {
    vpc_id = data.aws_vpc.default.id
    tags = {
      Name = "asg-homework-web"
    }

    // allows traffic from the SG itself
    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        self = true
    }

    // allow traffic for TCP 80
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["${var.source_cidr_block}"]
    }
    // allow trafic for TCP 22
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["${var.source_cidr_block}"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "rds_sg" {
    vpc_id = data.aws_vpc.default.id
    tags = {
      Name = "asg-homework-rds"
      }

    // allows traffic from the SG itself
    ingress {
        from_port = 0
        to_port   = 0
        protocol  = "-1"
        self      = true
    }

    // allow traffic for TCP 3306
    ingress {
        from_port   = 3306
        to_port     = 3306
        protocol    = "tcp"
        cidr_blocks = ["${data.aws_subnet.default_az1.cidr_block}"]
    }

    // outbound internet access
    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "mykeypair"{
  key_name   = "id_rsa"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "wp-webserver" {
  ami                         = var.instance_ami
  instance_type               = var.instance_type
  root_block_device  {
      volume_type   = "gp2"
      volume_size   = 15
    }
  key_name                    = aws_key_pair.mykeypair.key_name
  vpc_security_group_ids      = ["${aws_security_group.web_sg.id}"]
  subnet_id                   = data.aws_subnet.default_az1.id
  user_data                   = file("install_ansible.sh")
  associate_public_ip_address = true
}

resource "aws_db_instance" "rds" {
  allocated_storage      = "5"
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.7.30"
  instance_class         = "db.t2.micro"
  name                   = "wordpress"
  username               = "root"
  password               = var.rds_password
  vpc_security_group_ids = ["${aws_security_group.rds_sg.id}"]
  skip_final_snapshot    = true
}
