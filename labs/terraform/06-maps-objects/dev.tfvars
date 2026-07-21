environment      = "dev"
application_name = "flask-health-api"

common_tags = {
  Owner      = "devsecops-platform"
  ManagedBy  = "terraform"
  CostCenter = "learning"
}

server_config = {
  instance_type = "t3.micro"
  disk_size_gb  = 20
  monitoring    = true
}