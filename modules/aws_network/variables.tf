# Add variables
variable "default_tags" {
  #default = {}
  type        = map(any)
  description = "Default tags to be appliad to all AWS resources"
}

# Step 8 - Add variables
variable "prefix" {
  #default     = "week6"
  type        = string
  description = "Name prefix"
}

# Provisioning public subnets
variable "public_cidr_blocks" {
  default     = ["10.20.0.0/24", "10.20.1.0/24"]
  type        = list(string)
  description = "Public Subnet CIDRs"
}

#Provisioning private subnets
variable "private_cidr_blocks" {
  default     = ["10.20.3.0/24", "10.20.4.0/24"]
  type        = list(string)
  description = "Private Subnet CIDRs"
}
#VPC CIDR range
variable "vpc_cidr" {
    #default = "10.20.0.0/16"
    type = string
    description = "VPC to host static web site"
}

variable "env" {
    #default = "dev"
    type = string
    description = "Deployment Environment"
}