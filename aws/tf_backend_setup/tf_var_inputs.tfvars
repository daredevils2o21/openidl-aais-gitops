#aws account credential details
aws_account_id = "000246701835898000"
aws_access_key = "000AKIATS4ETIZ5AURBX4HH000"
aws_secret_key = "000IyM57kFB16whlEjH8NHuA/S+TPQMggFbauQ3DNWr000"
aws_user_arn = "arn:aws:iam::246701835898:user/openIDL"
aws_role_arn = "arn:aws:iam::246701835898:role/openidl-backend-resources-role"

#aws region to setup terraform background?
aws_region = "us-west-2"
aws_external_id = "openidl-backend-setup"

#Unique s3 bucket name to store terraform state files
tf_backend_s3_bucket = "openidl-backend-resources-state-files"

#name of the s3 bucket to use for managing input files for terraform
tf_inputs_s3_bucket = "openidl-backend-resources-input-files"

#Name of the dynamoDB table to manage terraform state files for AWS resource provisioning module
tf_backend_dynamodb_table_aws_resources = "openidl-tf-backend-aws-resources"

#Name of the dynamoDB table to manage terraform state files for K8S resource provisioning module
tf_backend_dynamodb_table_k8s_resources = "openidl-tf-backend-k8s-resources"

