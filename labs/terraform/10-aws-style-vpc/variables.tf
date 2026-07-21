variable "environment" {
  type    = string
  default = "dev"
}

variable "application_name" {
  type    = string
  default = "flask-health-api"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  type = map(string)

  default = {
    public-a = "10.0.1.0/24"
    public-b = "10.0.2.0/24"
  }
}

variable "private_subnets" {
  type = map(string)

  default = {
    private-a = "10.0.11.0/24"
    private-b = "10.0.12.0/24"
  }
}
