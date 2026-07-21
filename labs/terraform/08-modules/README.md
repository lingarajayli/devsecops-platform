# Terraform Lab 08: Modules

## Goal

Learn how Terraform modules make infrastructure code reusable.

---

## Concepts Covered

- Root module
- Child module
- Module inputs
- Module outputs
- Reusable infrastructure code
- `terraform fmt -recursive`

---

## Structure

```text
labs/terraform/08-modules/
├── main.tf
├── variables.tf
├── outputs.tf
├── dev.tfvars
└── modules/
    └── app_config/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

---

## What is a Module?

A Terraform module is a reusable block of Terraform code.

Think of it like a function:

```text
input variables -> module -> output values
```

---

## Root Module

The root module calls the child module:

```hcl
module "app_config" {
  source = "./modules/app_config"

  environment      = var.environment
  application_name = var.application_name
  replicas         = var.replicas
}
```

---

## Child Module

The child module creates the resource:

```hcl
resource "local_file" "app_config" {
  filename = "${path.module}/../../${var.environment}-${var.application_name}-module-config.json"

  content = jsonencode({
    environment      = var.environment
    application_name = var.application_name
    replicas         = var.replicas
    managed_by       = "terraform-module"
  })
}
```

---

## Commands

```bash
terraform init
terraform fmt -recursive
terraform plan -var-file="dev.tfvars"
terraform apply --auto-approve -var-file="dev.tfvars"
terraform output
```

---

## Key Learning

Terraform module address example:

```text
module.app_config.local_file.app_config
```

This means:

```text
local_file.app_config resource exists inside module.app_config
```

---

## Real-World Usage

Modules are used for reusable infrastructure such as:

```text
VPC module
EC2 module
S3 module
RDS module
EKS module
IAM module
Security group module
```

---

## Interview Summary

Terraform modules are reusable units of infrastructure code. The root module passes input variables to child modules, child modules create resources, and outputs expose useful values back to the root module. Modules help standardize infrastructure and reduce repeated code.