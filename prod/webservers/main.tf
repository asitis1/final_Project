# Terraform Config file (main.tf). This has provider block (AWS) and config for provisioning one EC2 instance resource.  

terraform {
required_providers {
  aws = {
  source = "hashicorp/aws"
  version = ">= 3.27"
 }
}

  required_version = ">=0.14"
} 
provider "aws" {
  profile = "default"
  region = "us-east-1"
}

data "terraform_remote_state" "public_subnet" { // This is to use Outputs from Remote State
  backend = "s3"
  config = {
    bucket = "abhiyan-assignment1"            // Bucket from where to GET Terraform State
    key    = "prod/network/terraform.tfstate" // Object name in the bucket to GET Terraform State
    region = "us-east-1"                       // Region where bucket created
  }
}

# Data source for AMI id
data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Data source for availability zones in us-east-1
data "aws_availability_zones" "available" {
  state = "available"
}

# Define tags locally
locals {
  default_tags = merge(var.default_tags, { "env" = var.env })
  name_prefix = "${var.prefix}-${var.env}"
}

resource "aws_instance" "acs73026" {
      
    ami                    = data.aws_ami.latest_amazon_linux.id
    instance_type          = lookup(var.instance_type, var.env)
    key_name               = aws_key_pair.week6.key_name
    security_groups        = [aws_security_group.acs730w5.id]
    subnet_id              = data.terraform_remote_state.public_subnet.outputs.public_subnet_ids[0]
    associate_public_ip_address = false
#    user_data  = file("${path.module}/install_httpd.sh")
        
               #user_data = file("${path.module}/install_httpd.sh")
    
     root_block_device {
     encrypted = var.env == "prod" ? true : false
     }

   lifecycle {
    create_before_destroy = true
   }  

  tags = merge(local.default_tags,
    {
      "Name" = "Amazon-Linux-prod-VM1"
    }
  )
}
resource "aws_instance" "acs73026-2" {
      
    ami                    = data.aws_ami.latest_amazon_linux.id
    instance_type          = lookup(var.instance_type, var.env)
    key_name               = aws_key_pair.week6.key_name
    security_groups        = [aws_security_group.acs730w5.id]
    subnet_id              = data.terraform_remote_state.public_subnet.outputs.public_subnet_ids[1]
    associate_public_ip_address = false
#    user_data  = file("${path.module}/install_httpd.sh")
        
               #user_data = file("${path.module}/install_httpd.sh")
    
     root_block_device {
     encrypted = var.env == "prod" ? true : false
     }

   lifecycle {
    create_before_destroy = true
   }  

  tags = merge(local.default_tags,
    {
      "Name" = "Amazon-Linux-prod-VM2"
    }
  )
}

# Adding SSH  key to instance
resource "aws_key_pair" "week6" {
  key_name   = "week6-prod"
  public_key = file("abhikey2.pub")
}

#security Group
resource "aws_security_group" "acs730w5" {
  name        = "allow_http_ssh_prod"
  description = "Allow HTTP and SSH inbound traffic"
  vpc_id      = data.terraform_remote_state.public_subnet.outputs.vpc_id 



  ingress {
    description      = "SSH from everywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(local.default_tags,
    {
      "Name" = "${var.prefix}-EBS"
    }
  )
}


# # Elastic IP
# resource "aws_eip" "static_eip" {
#   instance = aws_instance.acs73026.id
#   tags = merge(local.default_tags,
#     {
#       "Name" = "${var.prefix}-eip"
#     }
#   )
# }

# # Attach EBS volume
# resource "aws_volume_attachment" "ebs_att" {
#   count       = var.env == "prod" ? 1 : 0
#   device_name = "/dev/sdh"
#   volume_id   = aws_ebs_volume.web_ebs[count.index].id
#   instance_id = aws_instance.acs73026.id
# }

# # Create another EBS volume
# resource "aws_ebs_volume" "web_ebs" {
#   count             = var.env == "prod" ? 1 : 0
#   availability_zone = data.aws_availability_zones.available.names[1]
#   size              = 40

#   tags = merge(local.default_tags,
#     {
#       "Name" = "${var.prefix}-EBS"
#     }
#   )
# }

