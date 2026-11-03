<div align="center">

# 🔄 Terraform Drift Detection Engine

[![Terraform](https://img.shields.io/badge/Terraform-Drift_Detection-844FBA?style=for-the-badge&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-Scheduled_Cron-2088FF?style=for-the-badge&logo=githubactions&logoColor=white)](https://github.com/features/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=for-the-badge)](./LICENSE)

<p align="center">
  <b>Automated GitOps drift detection engine running scheduled reconciliations against live cloud infrastructure to flag out-of-band manual changes and push actionable Slack/Teams incident cards.</b>
</p>

</div>

---

## 🎯 The Problem

In large multi-team cloud platforms, engineers often make emergency manual adjustments directly in the Azure/AWS portal. This creates **configuration drift**, breaking future CI/CD deployments and violating compliance frameworks (SOC2, ISO 27001).

This engine runs non-destructive checks via `terraform plan -detailed-exitcode` and immediately notifies SRE teams when real-world infrastructure deviates from Git.

```
┌─────────────────────────────────┐
│ Scheduled Cron / Webhook Event  │
└────────────────┬────────────────┘
                 │
                 ▼
┌─────────────────────────────────┐
│ Run: terraform plan             │
│  -detailed-exitcode             │
└───────┬─────────────────┬───────┘
        │                 │
 (Exit 0: Aligned)   (Exit 2: DRIFT DETECTED)
        ▼                 ▼
┌───────────────┐ ┌──────────────────────────────────────┐
│  Log Success  │ │ - Capture diff from terraform plan   │
│  (Green CI)   │ │ - Post Rich Alert to Microsoft Teams │
└───────────────┘ │ - Open automated Reconciliation PR   │
                  └──────────────────────────────────────┘
```

---

## 📁 Repository Layout

```
terraform-drift-detection-engine/
├── .github/workflows/
│   └── drift-detection-cron.yml # Scheduled cron pipeline running every 6 hours
├── scripts/
│   ├── detect-drift.sh          # Wrapper script evaluating exit codes 0 vs 2
│   └── notify-teams.py          # Formats diff snippet into Microsoft Teams card
├── templates/
│   └── main.tf                  # Sample Azure IaC target configuration
└── README.md
```

---

## 👤 Author

**Vishwjeet Kumar Mehta**  
Senior DevOps & DevSecOps Consultant | Cloud & Infrastructure Architect  
- **LinkedIn**: [linkedin.com/in/vishwjeetmehta](https://linkedin.com/in/vishwjeetmehta)  
- **GitHub**: [@vishwjeetmehta-bot](https://github.com/vishwjeetmehta-bot)
