terraform {
  required_version = ">= 1.5.0"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

resource "local_file" "devops_note" {
  filename = "${path.module}/devops-note.txt"
  content  = "Terraform created this file for DevOps learning.\n"
}