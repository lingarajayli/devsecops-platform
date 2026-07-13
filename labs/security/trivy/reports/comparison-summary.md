# Trivy Image Scan Comparison

## Images Compared

| Image | Base OS | CRITICAL | HIGH | Total HIGH/CRITICAL |
|---|---|---:|---:|---:|
| `nginx:1.21` | Debian 11.3 | 28 | 185 | 213 |
| `nginx:stable-alpine` | Alpine 3.23 | 0 | 4 | 4 |

---

## Key Finding

The older `nginx:1.21` image had significantly more vulnerabilities because it used an older Debian base image.

The newer `nginx:stable-alpine` image had far fewer HIGH and CRITICAL vulnerabilities.

---

## Lesson Learned

Container image vulnerabilities often come from the base OS layer.

Before changing application code, always check:

```text
Base image
OS packages
Installed package versions
Fixed versions
Severity level
Whether a patch is available
```

---

## Remediation Strategy

```text
1. Upgrade to a newer base image
2. Prefer smaller images where suitable
3. Rebuild the image
4. Re-scan using Trivy
5. Compare before/after vulnerability counts
6. Block CRITICAL vulnerabilities in CI/CD
```

---

## Interview Explanation

When Trivy reports vulnerabilities, I first identify whether they come from OS packages, application dependencies, or the base image.

If the vulnerabilities come from the base image, I upgrade to a newer patched image or use a smaller image like Alpine where appropriate.

In this lab, switching from `nginx:1.21` to `nginx:stable-alpine` reduced HIGH and CRITICAL vulnerabilities from 213 to 4.

This shows why base image selection is important in container security.