output "public_subnet_ids" {
  value = module.vpc-prod.subnet_id
}

output "vpc_id" {
  value = module.vpc-prod.vpc_id
}