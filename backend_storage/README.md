# 🔧 Terraform Backend Storage – Quick Spinup

This Terraform configuration deploys a **secure Azure Storage Account and Container** to serve as a remote backend for storing Terraform state (`.tfstate`) files.

---

## 📌 Purpose

- Provides a one-off, reliable backend for Terraform state management.
- Implements **security best practices** like:
  - Blob versioning
  - Soft-delete for blobs and containers
  - Point-in-time restore
  - Enforced TLS 1.2
- Assigns scoped **RBAC** access (`Storage Blob Data Contributor`) to the specified Azure AD principal only at the container level.
- Ideal for **bootstrapping** infrastructure before transitioning to full modular IaC patterns.

---

## 📂 Structure

```bash
.
├── main.tf
├── variables.tf
├── outputs.tf
├── backend.tfvars.example
├── README.md

