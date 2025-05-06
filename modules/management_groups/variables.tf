variable "root_management_group_name" {
  type = string
}
variable "departments" {
  type = map(string)
}
variable "location" {
  type    = string
  default = "East US"
}
