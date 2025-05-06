resource "azurerm_policy_definition" "custom" {
  for_each     = { for pd in var.policy_definitions : pd.name => pd }
  name         = each.value.name
  policy_type  = "Custom"
  display_name = each.value.displayName
  policy_rule  = each.value.policyRule
  mode         = "Indexed"
}

resource "azurerm_policy_assignment" "custom" {
  for_each             = azurerm_policy_definition.custom
  name                 = "${each.key}-assignment"
  scope                = var.assign_scope
  policy_definition_id = each.value.id
}
