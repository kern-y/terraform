variable aws_region {
  default = "us-east-2"
}

variable aws_profile {
  default ="default"
}

variable source_cidr_block {
  description = "The source CIDR block to allow traffic from"
  default = "0.0.0.0/0"
}

variable instance_type {
  description = "Please define ec2 instance (eg. t2.micro)"
  default = "t2.micro"
}

variable instance_ami {
  default = "ami-0010d386b82bc06f0"
}

variable ansible_cfg {
  default = "../ansible/ansible.cfg"
}

variable rds_password {
  description = "Please define RDS MySQL password (min 8 length)"
  default     = "rdspassword1" #todo set to an env var
}
