resource "azurerm_management_group" "root" {
  display_name = var.root_management_group_name
  name         = var.root_management_group_name
}

resource "azurerm_management_group" "departments" {
  for_each     = var.departments
  display_name = each.value
  name         = each.key
  parent_management_group_id = azurerm_management_group.root.id
}

resource "azurerm_resource_group" "management" {
  name     = "rg-management"
  location = var.location
  tags = {
    environment = "platform"
  }
}
