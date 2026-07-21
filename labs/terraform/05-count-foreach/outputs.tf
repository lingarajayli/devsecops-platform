output "server_files" {
  value = local_file.server[*].filename
}

output "team_files" {
  value = {
    for role, file in local_file.team_member : role => file.filename
  }
}