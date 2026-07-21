variable "environment" {
  type    = string
  default = "dev"
}

variable "application_name" {
  type    = string
  default = "flask-health-api"
}

variable "server_count" {
  type    = number
  default = 2
}

variable "team_members" {
  type    = list(string)
  default = ["linux", "devops", "security"]
}