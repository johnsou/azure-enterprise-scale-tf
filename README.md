# Azure Enterprise-Scale Landing Zone

This repository provides a modular Terraform scaffold for deploying an enterprise-scale landing zone on Azure. Follow the steps below to get started quickly.

---

## 📁 Repository Structure

```
azure-enterprise-scale-tf/
├── modules/
│   ├── management_groups/
│   ├── network/
│   ├── log_analytics/
│   └── policy/
├── .github/workflows/
│   └── terraform.yml
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars.example   # Sample variables file
├── README.md                  # <-- this file
└── LICENSE
```

---

## 🛠 Prerequisites

* Terraform >= 1.3.0
* Azure CLI logged in with appropriate permissions (`az login`)
* A subscription with permissions to create management groups, resource groups, and policies

---

## 🚀 Getting Started

1. **Clone the repository**

   ```bash
   git clone https://github.com/johnsou/azure-enterprise-scale-tf.git
   cd azure-enterprise-scale-landing-zone
   ```

2. **Copy the example variables file**

   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

3. **Customize `terraform.tfvars`**

   * Update `root_mgmt_group` and `departments` to reflect your directory structure.
   * Modify `hub_address_space` and `spoke_vnets` CIDR blocks for your network.
   * Set `location` and `log_analytics_workspace_name` to your preferred Azure region and naming standards.
   * Add or replace entries in `policy_definitions` with your own policy JSON.

4. **Initialize Terraform**

   ```bash
   terraform init
   ```

5. **Review the plan**

   ```bash
   terraform plan
   ```

6. **Apply the configuration**

   ```bash
   terraform apply
   ```

---

## 🔍 Module Overview

* **management\_groups**: Creates a root management group, child department groups, and a management RG.
* **network**: Deploys a hub VNet, spoke VNets, and VNet peerings.
* **log\_analytics**: Provisions a Log Analytics workspace.
* **policy**: Defines and assigns custom policies.

Feel free to extend these modules with Azure Firewall, Bastion, Storage Accounts, Sentinel integration, and more.

---

## 🤖 CI/CD Integration

This repo includes a GitHub Actions workflow (.github/workflows/terraform.yml) that:

Runs terraform fmt and terraform init on every push.

Executes terraform plan on pull requests.

Runs terraform apply automatically when commits are merged into the main branch.

Ensure you have configured the required secrets (ARM_CLIENT_ID, ARM_CLIENT_SECRET, ARM_SUBSCRIPTION_ID, ARM_TENANT_ID) in your GitHub repository settings.

# .github/workflows/terraform.yml
name: 'Terraform CI/CD'

on:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main

jobs:
  terraform:
    name: 'Terraform'
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v2
        with:
          terraform_version: '1.3.0'

      - name: Terraform Init
        run: terraform init

      - name: Terraform Format
        run: terraform fmt -check

      - name: Terraform Plan
        id: plan
        run: terraform plan -input=false

      - name: Comment PR with Plan
        uses: marocchino/sticky-pull-request-comment@v2
        if: github.event_name == 'pull_request'
        with:
          number: ${{ github.event.pull_request.number }}
          body: |
            ## Terraform Plan
            ```
            ${{ steps.plan.outputs.stdout }}
            ```

      - name: Terraform Apply
        if: github.ref == 'refs/heads/main' && github.event_name == 'push'
        run: terraform apply -auto-approve
        env:
          ARM_CLIENT_ID: ${{ secrets.ARM_CLIENT_ID }}
          ARM_CLIENT_SECRET: ${{ secrets.ARM_CLIENT_SECRET }}
          ARM_SUBSCRIPTION_ID: ${{ secrets.ARM_SUBSCRIPTION_ID }}
          ARM_TENANT_ID: ${{ secrets.ARM_TENANT_ID }}

 ## 🤝 Contributing

Contributions and suggestions are welcome! Please open an issue or submit a pull request with any enhancements, bug fixes, or new modules.



## 📄 License

© 2025 John Sourgiadakis

This project is licensed under the MIT License. See the LICENSE file for details.
