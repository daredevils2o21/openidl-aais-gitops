# terraform {
#   backend "s3" {
#     # path = "terraform.tfstate"
#     bucket               = "openidl-backend-resources-state-files-umtotr"
#     key                  = "aws/terraform.tfstate"
#     region               = "us-east-1"
#     encrypt              = true
#     workspace_key_prefix = "env"
#     ##################reference example: https://dynamodb.us-east-1.amazonaws.com#################
#     dynamodb_endpoint    = "https://dynamodb.us-west-2.amazonaws.com"
#     dynamodb_table       = "openidl-tf-backend-aws-resources"
#     # role_arn             = "<IAM_role_arn>"
#     # session_name         = "terraform-session"
#     # external_id          = "<external_id>" #external id setup during IAM user and role setup for access
#   }

# }
