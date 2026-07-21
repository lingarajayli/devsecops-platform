variable "environment" {
  description = "Deployment environment name"
  type        = string
  default     = "dev"
}

variable "application_name" {
  description = "Application name"
  type        = string
  default     = "flask-health-api"
}

variable "owner" {
  description = "Team or owner responsible for this resource"
  type        = string
  default     = "devsecops-platform"
}

variable "instance_count" {
  description = "Number of application instances"
  type        = number
  default     = 1
}