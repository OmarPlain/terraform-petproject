variable "resource_group_name" {
  description = "The name of the resource group where the storage account will be created."
  type        = string
}

variable "storage_account_name" {
  description = "The name of the storage account to be used for Terraform state."
  type        = string
}