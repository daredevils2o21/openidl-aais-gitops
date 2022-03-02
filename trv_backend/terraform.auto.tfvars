#aws region to setup terraform background?
aws_region = "us-east-1"
aws_external_id = "terraform"

#Unique s3 bucket name to store terraform state files
tf_backend_s3_bucket = "openidl-backend-resources-state-files-offline-umtotr"

#name of the s3 bucket to use for managing input files for terraform
tf_inputs_s3_bucket = "openidl-backend-resources-input-files-offline-umtotr"

#Name of the dynamoDB table to manage terraform state files for AWS resource provisioning module
tf_backend_dynamodb_table_aws_resources = "openidl-tf-backend-aws-resources"

#Name of the dynamoDB table to manage terraform state files for K8S resource provisioning module
tf_backend_dynamodb_table_k8s_resources = "openidl-tf-backend-k8s-resources"

#Vars Needed for Travelers
classification = "internal"
owner1 = ""
owner2 = ""

aws_account_id = ""
aws_access_key = ""
aws_secret_key = ""
aws_user_arn = ""
aws_role_arn = ""
