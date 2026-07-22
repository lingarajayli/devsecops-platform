# Terraform Provider Plugin Cache

## Goal

Avoid downloading Terraform providers again and again for every lab.

Terraform normally creates a `.terraform/` directory inside each working folder. Without a plugin cache, each lab may download the same provider again.

---

## Solution

Use Terraform provider plugin cache.

Create cache directory:

```bash
mkdir -p ~/.terraform.d/plugin-cache
```

Create Terraform CLI config:

```bash
cat > ~/.terraformrc <<'EOF'
plugin_cache_dir = "$HOME/.terraform.d/plugin-cache"
EOF
```

---

## Why This Helps

Terraform labs use providers such as:

```text
hashicorp/aws
hashicorp/local
```

With plugin cache enabled, Terraform downloads the provider once and reuses it across labs.

---

## What Not to Commit

Never commit:

```text
.terraform/
terraform.tfstate
terraform.tfstate.backup
```

Commit only:

```text
main.tf
variables.tf
outputs.tf
README.md
.terraform.lock.hcl
```

---

## Verify

Run:

```bash
terraform init
```

Then check cache:

```bash
ls -la ~/.terraform.d/plugin-cache
```

---

## Interview Summary

I configured Terraform provider plugin caching locally to avoid repeated provider downloads across labs. This improves developer experience while keeping `.terraform/` and state files out of Git.