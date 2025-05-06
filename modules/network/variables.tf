variable "hub_vnet_name" { type = string }
variable "hub_address_space" { type = list(string) }
variable "spoke_vnets" {
  type = map(object({
    name          = string
    address_space = list(string)
  }))
}
variable "location" { type = string }
