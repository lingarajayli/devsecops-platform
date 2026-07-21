output "vpc_name" {
  value = local.vpc_design.name
}

output "vpc_cidr" {
  value = local.vpc_design.cidr
}

output "public_subnets" {
  value = local.vpc_design.public_subnets
}

output "private_subnets" {
  value = local.vpc_design.private_subnets
}