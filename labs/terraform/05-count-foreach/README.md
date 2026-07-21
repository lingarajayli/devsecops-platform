# Terraform Lab 05: count and for_each

## Goal

Learn how to create multiple resources using `count` and `for_each`.

---

## Concepts Covered

- `count`
- `count.index`
- `for_each`
- `each.key`
- lists
- sets
- multiple resource creation

---

## count Example

```hcl
resource "local_file" "server" {
  count = var.server_count

  filename = "${path.module}/${var.environment}-server-${count.index + 1}.txt"
  content  = "Server ${count.index + 1} for ${var.application_name} in ${var.environment}\n"
}
```

This creates multiple similar resources.

Example output:

```text
dev-server-1.txt
dev-server-2.txt
```

---

## for_each Example

```hcl
resource "local_file" "team_member" {
  for_each = toset(var.team_members)

  filename = "${path.module}/${var.environment}-team-${each.key}.txt"
  content  = "Team member role: ${each.key}\n"
}
```

This creates resources using meaningful keys.

Example output:

```text
dev-team-linux.txt
dev-team-devops.txt
dev-team-security.txt
```

---

## Commands

```bash
terraform init
terraform fmt
terraform plan -var-file="dev.tfvars"
terraform apply --auto-approve -var-file="dev.tfvars"
terraform output
```

---

## Key Difference

| Feature | Best For | Identifier |
|---|---|---|
| `count` | Simple repeated resources | Numeric index |
| `for_each` | Named resources | Key/value |

---

## Real-World Examples

Use `count` for:

```text
Create 3 test instances
Create N local files
Create repeated simple resources
```

Use `for_each` for:

```text
Security group rules
Subnets by name
IAM users
S3 buckets by name
Environment-specific resources
```

---

## Interview Summary

`count` is useful when creating a fixed number of similar resources. `for_each` is better when each resource needs a stable name or key. In production Terraform, `for_each` is often preferred because it avoids index-based replacement issues.