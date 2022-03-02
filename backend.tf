terraform {
  backend "s3" {
    # path = "terraform.tfstate"
    bucket               = "openidl-backend-resources-state-files-offline-umtotr"
    key                  = "aws/terraform.tfstate"
    region               = "us-east-1"
    encrypt              = true
    workspace_key_prefix = "env"
    ##################reference example: https://dynamodb.us-east-1.amazonaws.com#################
    dynamodb_endpoint    = "https://dynamodb.us-east-1.amazonaws.com"
    dynamodb_table       = "openidl-tf-backend-aws-resources"
    role_arn             = "arn:aws:iam::246701835898:role/tf_automation"
    session_name         = "terraform-session"
    external_id          = "terraform" #external id setup during IAM user and role setup for access
  }

}