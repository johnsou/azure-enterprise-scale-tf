variable "root_mgmt_group" {
  type        = string
  description = "Name of the Azure root management group"
}

variable "departments" {
  type = map(string)
  description = "Map of department codes to management group names"
}

variable "hub_vnet_name" {
  type        = string
  description = "Name of the Hub Virtual Network"
}

variable "hub_address_space" {
  type        = list(string)
  description = "Address space for the hub VNet"
}

variable "spoke_vnets" {
  type = map(object({
    name          = string
    address_space = list(string)
  }))
  description = "Map of spoke VNets with names and address spaces"
}

variable "location" {
  type        = string
  description = "Azure region for resources"
  default     = "East US"
}

variable "log_analytics_workspace_name" {
  type        = string
  description = "Name for the Log Analytics workspace"
}

variable "policy_definitions" {
  type = list(object({
    name        = string
    displayName = string
    policyRule  = any
  }))
  description = "List of custom policy definitions"
}
