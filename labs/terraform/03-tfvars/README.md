# Terraform Lab 03: tfvars

## Goal

Learn how to use `.tfvars` files to manage environment-specific Terraform values.

---

## Concepts Covered

- `terraform.tfvars`
- custom tfvars files
- `-var-file`
- environment-specific values
- safe example variable files

---

## Files

```text
labs/terraform/03-tfvars/
├── main.tf
├── variables.tf
├── outputs.tf
├── dev.tfvars
├── prod.tfvars.example
├── README.md
└── .terraform.lock.hcl
```

---

## dev.tfvars

```hcl
environment      = "dev"
application_name = "flask-health-api"
owner            = "devsecops-platform"
instance_count   = 1
```

---

## prod.tfvars.example

```hcl
environment      = "prod"
application_name = "flask-health-api"
owner            = "devsecops-platform"
instance_count   = 3
```

---

## Commands

Initialize:

```bash
terraform init
```

Plan with dev values:

```bash
terraform plan -var-file="dev.tfvars"
```

Apply with dev values:

```bash
terraform apply --auto-approve -var-file="dev.tfvars"
```

Plan with prod example values:

```bash
terraform plan -var-file="prod.tfvars.example"
```

---

## Key Learning

Using `-var-file` allows the same Terraform code to be reused for different environments.

Example:

```text
dev.tfvars           -> dev-inventory.txt
prod.tfvars.example  -> prod-inventory.txt
```

When variable values change the resource filename, Terraform must replace the resource.

---

## Security Note

Do not commit real secret tfvars files.

Safe:

```text
dev.tfvars
prod.tfvars.example
```

Avoid committing:

```text
prod.tfvars
secrets.tfvars
*.auto.tfvars with secrets
```

---

## Interview Summary

Terraform tfvars files are used to separate configuration from environment-specific values. In real projects, teams commonly keep safe example files in Git and inject sensitive values through CI/CD secrets, secret managers, or secure backend workflows.