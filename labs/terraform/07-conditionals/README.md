# Terraform Lab 07: Conditional Expressions

## Goal

Learn how to use conditional expressions to change Terraform values based on environment.

---

## Concepts Covered

- Conditional expressions
- Environment-based configuration
- Dev vs prod differences
- Resource replacement caused by changed values

---

## Conditional Syntax

```hcl
condition ? value_if_true : value_if_false
```

Example:

```hcl
instance_type = var.environment == "prod" ? "t3.medium" : "t3.micro"
```

Meaning:

```text
If environment is prod, use t3.medium.
Otherwise, use t3.micro.
```

---

## Dev Behavior

```text
environment   = dev
instance_type = t3.micro
monitoring    = false
replicas      = 1
```

---

## Prod Behavior

```text
environment   = prod
instance_type = t3.medium
monitoring    = true
replicas      = 3
```

---

## Commands

```bash
terraform init
terraform fmt
terraform apply --auto-approve -var-file="dev.tfvars"
terraform plan -var-file="prod.tfvars.example"
```

---

## Key Learning

Conditional expressions allow the same Terraform code to behave differently for different environments.

This is useful for:

```text
Dev vs prod instance sizes
Enable monitoring only in prod
Different replica counts
Different backup settings
Different deletion protection settings
```

---

## Interview Summary

Terraform conditional expressions are used to choose values based on a condition. In production, they are commonly used to change settings between environments, such as using smaller resources in dev and stronger settings in prod.