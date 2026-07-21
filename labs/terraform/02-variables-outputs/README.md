# Terraform Lab 02: Variables and Outputs

## Goal

Learn how Terraform variables and outputs make infrastructure reusable.

---

## Concepts Covered

- Input variables
- Default values
- Variable overrides using `-var`
- Outputs
- Resource replacement
- `terraform fmt`

---

## What this lab creates

Terraform creates an inventory file based on variable values.

Example:

```text
dev-inventory.txt
prod-inventory.txt
```

---

## Commands Used

```bash
terraform init
terraform fmt
terraform plan
terraform apply --auto-approve
terraform output
```

Override variables:

```bash
terraform apply --auto-approve \
  -var="environment=prod" \
  -var="instance_count=3"
```

---

## Key Learning

Variables make the same Terraform code reusable for different environments.

Example:

```text
environment = dev  -> dev-inventory.txt
environment = prod -> prod-inventory.txt
```

Changing the filename caused Terraform to replace the resource:

```text
1 destroyed
1 created
```

---

## Interview Summary

Terraform variables allow infrastructure code to be reused across environments like dev, staging, and prod. Outputs expose useful values after provisioning, such as file paths, IPs, DNS names, or resource IDs.