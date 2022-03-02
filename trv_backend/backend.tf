module "backend" {
    source = "../aws/tf_backend_setup"
    aws_account_id = var.aws_account_id
    #aws_user_arn = var.aws_user_arn
    #aws_access_key = var.aws_access_key
    aws_role_arn = var.aws_role_arn

    tf_backend_dynamodb_table_k8s_resources = var.tf_backend_dynamodb_table_k8s_resources
    tf_inputs_s3_bucket = var.tf_inputs_s3_bucket
    tf_backend_s3_bucket = var.tf_backend_s3_bucket
    tf_backend_dynamodb_table_aws_resources = var.tf_backend_dynamodb_table_aws_resources
    
    aws_external_id = var.aws_external_id

    #Needed for Travelers
    classification = var.classification
    owner1 = var.owner1
    owner2 = var.owner2

}