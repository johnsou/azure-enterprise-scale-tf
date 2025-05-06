resource "azurerm_resource_group" "network" {
  name     = "rg-network"
  location = var.location
  tags = { environment = "network" }
}

resource "azurerm_virtual_network" "hub" {
  name                = var.hub_vnet_name
  address_space       = var.hub_address_space
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name
}

resource "azurerm_virtual_network" "spokes" {
  for_each            = var.spoke_vnets
  name                = each.value.name
  address_space       = each.value.address_space
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name
}

# VNet peerings
resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  for_each                          = azurerm_virtual_network.spokes
  name                              = "${azurerm_virtual_network.hub.name}-to-${each.value.name}"
  resource_group_name               = azurerm_resource_group.network.name
  virtual_network_name              = azurerm_virtual_network.hub.name
  remote_virtual_network_id         = each.value.id
  allow_forwarded_traffic           = true
  allow_gateway_transit             = false
  use_remote_gateways               = false
}
