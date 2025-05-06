terraform {
  required_version = ">= 1.3.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.50.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# 1) Management Groups
module "mg" {
  source = "./modules/management_groups"

  root_management_group_name = var.root_mgmt_group
  departments                = var.departments
}

# 2) Hub & Spoke Networking
module "network" {
  source = "./modules/network"

  hub_vnet_name      = var.hub_vnet_name
  hub_address_space  = var.hub_address_space
  spoke_vnets        = var.spoke_vnets
  management_rg_name = module.mg.management_rg_name
}

# 3) Log Analytics Workspace
module "log_analytics" {
  source              = "./modules/log_analytics"
  workspace_name      = var.log_analytics_workspace_name
  resource_group_name = module.mg.monitoring_rg_name
  location            = var.location
}

# 4) Policy Definitions & Assignments
module "policy" {
  source              = "./modules/policy"
  policy_definitions  = var.policy_definitions
  assign_scope        = module.mg.root_mg_id
}

# Outputs
output "hub_vnet_id" {
  value = module.network.hub_vnet_id
}

output "log_analytics_workspace_id" {
  value = module.log_analytics.workspace_id
}
