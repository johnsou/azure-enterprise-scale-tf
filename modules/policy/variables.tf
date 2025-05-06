variable "policy_definitions" {
  type = list(object({
    name        = string
    displayName = string
    policyRule  = any
  }))
}
variable "assign_scope" {
  type = string
}
