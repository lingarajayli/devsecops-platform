variable "environment" {
  type    = string
  default = "dev"
}

variable "application_name" {
  type    = string
  default = "flask-health-api"
}

variable "common_tags" {
  type = map(string)

  default = {
    Owner     = "devsecops-platform"
    ManagedBy = "terraform"
  }
}

variable "server_config" {
  type = object({
    instance_type = string
    disk_size_gb  = number
    monitoring    = bool
  })

  default = {
    instance_type = "t3.micro"
    disk_size_gb  = 20
    monitoring    = true
  }
}