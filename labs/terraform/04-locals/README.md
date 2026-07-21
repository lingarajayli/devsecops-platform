# Terraform Lab 04: Locals

## Goal

Learn how to use Terraform `locals` to avoid repetition and create consistent naming and tagging standards.

---

## Concepts Covered

- `locals`
- calculated values
- naming standards
- common tags
- `jsonencode`
- outputs from locals

---

## Why Locals Matter

Locals help keep Terraform code clean.

Instead of repeating values many times, define them once and reuse them.

Example:

```hcl
locals {
  name_prefix = "${var.environment}-${var.application_name}"
}
```

This can be reused for resource names.

---

## Common Tags Example

```hcl
locals {
  common_tags = {
    Environment = var.environment
    Application = var.application_name
    Owner       = var.owner
    ManagedBy   = "terraform"
  }
}
```

In AWS, similar tags are commonly applied to resources like EC2, VPC, S3, RDS, and EKS.

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
dev-flask-health-api-tags.txt
```

Example content:

```json
{"Application":"flask-health-api","Environment":"dev","ManagedBy":"terraform","Owner":"devsecops-platform"}
```

---

## Interview Summary

Terraform locals are used to define reusable calculated values inside a module. They are useful for consistent resource naming, common tags, and avoiding repeated expressions across Terraform code.