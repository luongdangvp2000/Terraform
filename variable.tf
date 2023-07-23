variable "region" {
  type = string
  default = "ap-southeast-1"
}

variable "project" {
  type = string
  default = "test-terraform"
}

variable "principal_arns" {
  type = list(string)
  default = null
  description = "A list of principal arns allowed to assume the IAM role"
}