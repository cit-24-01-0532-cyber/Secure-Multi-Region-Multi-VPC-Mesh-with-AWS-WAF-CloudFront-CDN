# Secure Multi-Region Multi-VPC Mesh with AWS WAF & CloudFront CDN

An enterprise-grade, highly available network architecture deployed on AWS using Terraform (Infrastructure as Code). This project demonstrates multi-environment isolation, secure cross-VPC communication via Full-Mesh Peering, and edge security orchestration.

## 🌐 Architecture Highlights
- **Multi-Environment VPC Mesh:** Separated VPCs for `Dev`, `Staging`, and `Prod` isolated from each other but connected securely via full-mesh VPC Peering.
- **Edge Protection (AWS WAFv2):** Configured with AWS Managed Rulesets (`AWSManagedRulesCommonRuleSet`) to mitigate OWASP Top 10 vulnerabilities (SQL Injection, XSS) at the edge.
- **Global Content Delivery (CloudFront):** Implemented HTTPS enforcement and caching behaviors to accelerate production web traffic globally.
- **Multi-Provider Terraform Setup:** Leveraged explicit provider aliasing to orchestrate cross-region resources simultaneously (Singapore for VPCs and N. Virginia for Global WAF Scope).

## 🛠️ Tech Stack
- **IaC:** Terraform (v5.0+ AWS Provider)
- **AWS Services:** VPC, VPC Peering, CloudFront, AWS WAFv2
