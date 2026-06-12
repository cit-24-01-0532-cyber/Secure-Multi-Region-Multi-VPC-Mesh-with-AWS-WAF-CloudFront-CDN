# Security Policy

## Reporting Vulnerabilities

If you discover a security vulnerability in this project, please report it responsibly by emailing the maintainers directly. Do **not** open a public GitHub issue for security vulnerabilities.

## Security Guidelines for Contributors

### Secrets Management
- **Never** commit secrets, API keys, credentials, or `.tfvars` files containing sensitive values.
- Use environment variables or AWS Secrets Manager / Parameter Store for sensitive configuration.
- The `.gitignore` in this repo blocks common secret file patterns — do not bypass it.

### Terraform
- Pin provider and module versions to avoid supply-chain attacks.
- Store `terraform.tfstate` in a remote backend (S3 + DynamoDB) with encryption enabled — never commit state files.
- Use `terraform plan` review before applying changes.
- Enable S3 bucket versioning on the state backend for recovery.

### Frontend
- The `index.html` includes a Content Security Policy (CSP) that restricts script sources to `'self'`. Update the CSP if you add external CDN scripts or API origins.
- Do not use `eval()`, `innerHTML`, or `document.write()` in client-side code.
- Validate and sanitize all user input on both client and server.

### AWS / Infrastructure
- Apply the principle of least privilege to all IAM roles and policies.
- Enable CloudTrail logging in all regions.
- Use HTTPS everywhere — the CloudFront distribution should enforce `redirect-to-https`.
- Keep WAF rule sets up to date with AWS Managed Rules.
