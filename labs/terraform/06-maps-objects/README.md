# Terraform Lab 06: Maps and Object Variables

## Goal

Learn how to use maps and object variables for structured Terraform configuration.

---

## Concepts Covered

- `map(string)`
- `object`
- `merge()`
- structured configuration
- common tags
- `jsonencode`

---

## Map Example

```hcl
variable "common_tags" {
  type = map(string)
}
```

Used for key/value tags:

```hcl
common_tags = {
  Owner      = "devsecops-platform"
  ManagedBy  = "terraform"
  CostCenter = "learning"
}
```

---

## Object Example

```hcl
variable "server_config" {
  type = object({
    instance_type = string
    disk_size_gb  = number
    monitoring    = bool
  })
}
```

Used for grouped server settings.

---

## merge Example

```hcl
locals {
  merged_tags = merge(
    var.common_tags,
    {
      Environment = var.environment
      Application = var.application_name
    }
  )
}
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

## Output File

Terraform creates:

```text
dev-server-config.json
```

Example content:

```json
{
  "application": "flask-health-api",
  "environment": "dev",
  "server_config": {
    "disk_size_gb": 20,
    "instance_type": "t3.micro",
    "monitoring": true
  },
  "tags": {
    "Application": "flask-health-api",
    "CostCenter": "learning",
    "Environment": "dev",
    "ManagedBy": "terraform",
    "Owner": "devsecops-platform"
  }
}
```

---

## Real-World Usage

Maps are commonly used for:

```text
Tags
Labels
Environment settings
Feature flags
```

Objects are commonly used for:

```text
EC2 instance config
VPC config
Subnet config
RDS config
Application config
```

---

## Interview Summary

Terraform maps store key/value pairs, commonly used for tags. Object variables define structured configuration with fixed fields and types. In production Terraform, maps and objects help keep modules reusable, strongly typed, and easier to validate.