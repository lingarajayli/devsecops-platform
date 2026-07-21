terraform {
  required_version = ">= 1.5.0"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

resource "local_file" "server" {
  count = var.server_count

  filename = "${path.module}/${var.environment}-server-${count.index + 1}.txt"
  content  = "Server ${count.index + 1} for ${var.application_name} in ${var.environment}\n"
}

resource "local_file" "team_member" {
  for_each = toset(var.team_members)

  filename = "${path.module}/${var.environment}-team-${each.key}.txt"
  content  = "Team member role: ${each.key}\n"
}