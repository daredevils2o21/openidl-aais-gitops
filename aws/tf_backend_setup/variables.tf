#aws environment specific variables
variable "aws_region" {
  default     = "us-east-1"
  type        = string
  description = "The aws region to deploy the infrastructure"
  validation {
    condition     = can(regex("([a-z]{2})-(.*)-([0-9])", var.aws_region))
    error_message = "The aws region must be entered in acceptable format, ex: us-east-2."
  }
}
variable "classification" {
  type        = string
  description = "Data classification. Needed for Travelers"
}
variable "owner1" {
  type = string
  description = "Bucket owner. Needed for Travelers"
}
variable "owner2" {
  type        = string
  description = "Bucket owner. Needed for Travelers"
}
variable "aws_role_arn" {
  type = string
  description = "The aws iam role arn to be assumed by the iam user"
}
variable "aws_external_id" {
  type = string
  #default = "terraform"
  description = "The external id used as extra condition as a best practice"
}
variable "tags" {
  type = map
  default = {}
}
variable "aws_account_id" {
  type = string
  description = "The account number of the aws account used"
}

#terraform backend specific variables
variable "tf_backend_s3_bucket" {
  type = string
  description = "The s3 bucket to store terraform state files"
}
variable "tf_backend_dynamodb_table_aws_resources" {
  type = string
  description = "The dynamodb table to manage terraform state file locking for aws resources"
}
variable "tf_backend_dynamodb_table_k8s_resources" {
  type = string
  description = "The dynamodb table to manage terraform state file locking for k8s resources"
}
variable "tf_inputs_s3_bucket" {
  type = string
  description = "The name of s3 bucket to manage terraform input files"
}
