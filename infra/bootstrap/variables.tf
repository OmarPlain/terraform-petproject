variable "resource_group_name" {
  description = "The name of the resource group where the storage account will be created."
  type        = string
}

variable "storage_account_name" {
  description = "The name of the storage account to be used for Terraform state."
  type        = string
}

variable "github_actions_principal_id" {
  description = "The principal ID of the GitHub Actions service principal."
  type        = string
}