
# resource "tls_private_key" "that" {
#   algorithm = "RSA"
# }

# module "aws_resources" {
#     depends_on = [
#       tls_private_key.that
#     ]
#     source = "./aws/aws_resources"
#     aws_account_number = var.aws_account_id

#     app_eks_worker_nodes_ssh_key = tls_private_key.that.public_key_openssh
#     blk_bastion_ssh_key = tls_private_key.that.public_key_openssh
#     app_bastion_ssh_key = tls_private_key.that.public_key_openssh
#     blk_eks_worker_nodes_ssh_key = tls_private_key.that.public_key_openssh


#     aws_role_arn = var.aws_role_arn


#     #set org name as below
#     #when nodetype is aais set org_name="aais"
#     #when nodetype is analytics set org_name="analytics"
#     #when nodetype is aais's dummy carrier set org_name="carrier" and for other carriers refer to next line.
#     #when nodetype is other carrier set org_name="<carrier_org_name>" , example: org_name = "travelers" etc.,

#     org_name = "trv" # For aais set to aais, for analytics set to analytics, for carriers set their org name, ex: travelers
#     aws_env = "dev" #set to dev|test|prod
#     #--------------------------------------------------------------------------------------------------------------------
#     #Application cluster VPC specifications
#     app_vpc_cidr           = "172.26.0.0/16"
#     app_availability_zones = ["us-east-1a", "us-east-1b"]
#     app_public_subnets     = ["172.26.1.0/24", "172.26.2.0/24"]
#     app_private_subnets    = ["172.26.3.0/24", "172.26.4.0/24"]

#     #-------------------------------------------------------------------------------------------------------------------
#     #Blockchain cluster VPC specifications
#     blk_vpc_cidr           = "172.27.0.0/16"
#     blk_availability_zones = ["us-east-1a", "us-east-1b"]
#     blk_public_subnets     = ["172.27.1.0/24", "172.27.2.0/24"]
#     blk_private_subnets    = ["172.27.3.0/24", "172.27.4.0/24"]

#     #--------------------------------------------------------------------------------------------------------------------
#     #Bastion host specifications
#     #bastion hosts are placed behind nlb. These NLBs can be configured to be private | public to serve SSH.
#     #In any case whether the endpoint is private|public for an nlb, the source ip_address|cidr_block should be enabled
#     #in bastion hosts security group for ssh traffic

#     bastion_host_nlb_external = "true"

#     #application cluster bastion host specifications
#     app_bastion_sg_ingress =  [
#     {rule="ssh-tcp", cidr_blocks = "172.26.0.0/16"},
#     {rule="ssh-tcp", cidr_blocks = "3.237.88.84/32"}]
#     app_bastion_sg_egress  =   [
#     {rule="https-443-tcp", cidr_blocks = "0.0.0.0/0"},
#     {rule="http-80-tcp", cidr_blocks = "0.0.0.0/0"},
#     {rule="ssh-tcp", cidr_blocks = "172.26.0.0/16"}] #additional ip_address|cidr_block should be included for ssh

#     #blockchain cluster bastion host specifications
#     #bastion host security specifications
#     blk_bastion_sg_ingress =  [
#     {rule="ssh-tcp", cidr_blocks = "172.27.0.0/16"},
#     {rule="ssh-tcp", cidr_blocks = "3.237.88.84/32"}]
#     blk_bastion_sg_egress  = [
#     {rule="https-443-tcp", cidr_blocks = "0.0.0.0/0"},
#     {rule="http-80-tcp", cidr_blocks = "0.0.0.0/0"},
#     {rule="ssh-tcp", cidr_blocks = "172.27.0.0/16"}] #additional ip_address|cidr_block should be included for ssh

#     #--------------------------------------------------------------------------------------------------------------------
#     #Route53 (PUBLIC) DNS domain related specifications
#     domain_info = {
#     r53_public_hosted_zone_required = "yes",  #options: yes | no
#     domain_name = "travelersdemo.com", #primary domain registered
#     sub_domain_name = "trv", #subdomain name
#     comments = "travelers node dns name resolutions"
#     }
#     #-------------------------------------------------------------------------------------------------------------------
#     #Transit gateway  specifications
#     tgw_amazon_side_asn = "64532" #default is 64532

#     #--------------------------------------------------------------------------------------------------------------------
#     #Cognito specifications
#     userpool_name                = "openidl"
#     client_app_name              = "openidl-client"
#     client_callback_urls         = ["https://openidl.dev.trv.travelersdemo.com/callback", "https://openidl.dev.trv.travelersdemo.com/redirect"]
#     client_default_redirect_url  = "https://openidl.dev.trv.travelersdemo.com/redirect"
#     client_logout_urls           = ["https://openidl.dev.trv.travelersdemo.com/signout"]
#     cognito_domain               = "travelersdemo" #unique domain name
#     email_sending_account        = "COGNITO_DEFAULT" # Options: COGNITO_DEFAULT | DEVELOPER
#     # COGNITO_DEFAULT - Uses cognito default and SES related inputs goes to empty in git secrets
#     # DEVELOPER - Ensure inputs ses_email_identity and userpool_email_source_arn are setup in git secrets
#     #--------------------------------------------------------------------------------------------------------------------
#     #Any additional traffic in future required to open to worker nodes, the below section needs to be set
#     app_eks_workers_app_sg_ingress = [] #{from_port, to_port, protocol, description, cidr_blocks}
#     app_eks_workers_app_sg_egress = [{rule = "all-all"}]

#     #Any additional traffic in future required to open to worker nodes, the below section needs to be set
#     blk_eks_workers_app_sg_ingress = [] #{from_port, to_port, protocol, description, cidr_blocks}
#     blk_eks_workers_app_sg_egress = [{rule = "all-all"}]

#     #--------------------------------------------------------------------------------------------------------------------
#     # application cluster EKS specifications
#     app_cluster_name              = "app-cluster"
#     app_cluster_version           = "1.20"
#     app_worker_nodes_ami_id = ""

#     #--------------------------------------------------------------------------------------------------------------------
#     # blockchain cluster EKS specifications
#     blk_cluster_name              = "blk-cluster"
#     blk_cluster_version           = "1.20"
#     blk_worker_nodes_ami_id = ""

#     #--------------------------------------------------------------------------------------------------------------------
#     #cloudtrail related
#     cw_logs_retention_period = 90
#     s3_bucket_name_cloudtrail = "cloudtrail-logs"

#     #--------------------------------------------------------------------------------------------------------------------
#     #Name of the S3 bucket managing terraform state files
#     terraform_state_s3_bucket_name = "openidl-backend-resources-state-files-offline-umtotr"


#     /*Default configuration specifications are listed here. If anything required specific to node_type and
#     environment, it requires updates here*/
#     #-------------------------------------------------------------------------------------------------------------------
#     #Bastion host configuration
#     instance_type                 = "t2.micro"
#     root_block_device_volume_type = "gp2"
#     root_block_device_volume_size = "40"
#     #-------------------------------------------------------------------------------------------------------------------
#     #Cognito default configurations
#     client_allowed_oauth_flows                       = ["code", "implicit"] # [code,implicit,client_credentials] are options
#     client_allowed_oauth_flows_user_pool_client      = true
#     client_allowed_oauth_scopes                      = ["email", "phone", "profile", "openid", "aws.cognito.signin.user.admin"]
#     client_explicit_auth_flows                       = ["ALLOW_ADMIN_USER_PASSWORD_AUTH", "ALLOW_USER_PASSWORD_AUTH", "ALLOW_REFRESH_TOKEN_AUTH", "ALLOW_USER_SRP_AUTH"]
#     client_generate_secret                           = false
#     client_read_attributes                           = ["address", "birthdate", "email", "email_verified", "family_name", "gender", "given_name", "locale", "middle_name", "name", "nickname", "phone_number", "phone_number_verified", "picture", "preferred_username", "profile", "zoneinfo", "updated_at", "website", "custom:role", "custom:stateName", "custom:stateCode", "custom:organizationId"]
#     client_write_attributes                          = ["address", "birthdate", "email", "family_name", "gender", "given_name", "locale", "middle_name", "name", "nickname", "phone_number", "picture", "preferred_username", "profile", "zoneinfo", "updated_at", "website", "custom:role", "custom:stateName", "custom:stateCode", "custom:organizationId"]
#     client_supported_idp                             = ["COGNITO"]
#     client_prevent_user_existence_errors             = "ENABLED"
#     client_id_token_validity                         = 1 #hour
#     client_access_token_validity                     = 1 #hour
#     client_refresh_token_validity                    = 5 #day
#     userpool_recovery_mechanisms                     = [{ name : "verified_email", priority : "1" }] #Options verified_phone_number|admin_only|verified_email
#     userpool_username_attributes                     = ["email"]
#     userpool_auto_verified_attributes                = ["email"]
#     userpool_mfa_configuration                       = "OPTIONAL"
#     userpool_software_token_mfa_enabled              = false
#     password_policy_minimum_length                   = 10
#     password_policy_require_lowercase                = true
#     password_policy_require_numbers                  = true
#     password_policy_require_symbols                  = true
#     password_policy_require_uppercase                = true
#     password_policy_temporary_password_validity_days = 10
#     userpool_advanced_security_mode                  = "AUDIT"
#     userpool_enable_username_case_sensitivity        = false
#     userpool_email_verification_subject              = "Your password"
#     userpool_email_verification_message              = "Your username is {username} and password is {####}."
#     #-------------------------------------------------------------------------------------------------------------------
#     #EKS cluster specifications
#     eks_worker_instance_type             = "t3.medium"
#     kubeconfig_output_path               = "./kubeconfig_file/"
#     manage_aws_auth                      = false
#     cluster_endpoint_private_access      = true
#     cluster_endpoint_public_access       = true
#     cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]
#     cluster_create_timeout               = "30m"
#     wait_for_cluster_timeout             = "300"
#     eks_cluster_logs                     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

#     #### Worker Groups Variables###
#     wg_asg_min_size             = "1"
#     wg_asg_max_size             = "2"
#     wg_asg_desired_capacity     = "1"
#     wg_ebs_optimized            = true
#     wg_instance_refresh_enabled = false
#     eks_wg_public_ip            = false
#     eks_wg_root_vol_encrypted   = true
#     eks_wg_root_volume_size     = "40"
#     eks_wg_root_volume_type     = "gp2"
#     eks_wg_block_device_name    = "/dev/sdf"
#     eks_wg_ebs_volume_size      = 100
#     eks_wg_ebs_volume_type      = "gp2"
#     eks_wg_ebs_vol_encrypted    = true
#     eks_wg_health_check_type    = "EC2"



    
# }

# module "k8s_resources" {
#     source = "./aws/k8s_resources"

#     aws_region = var.aws_region
#     org_name = module.aws_resources.org_name # For aais set to aais, for analytics set to analytics, for carriers set their org name, ex: travelers
#     aws_env = module.aws_resources.aws_env #set to dev|test|prod


#     domain_info = {
#     r53_public_hosted_zone_required = "yes",  #options: yes | no
#     domain_name = "travelersdemo.com", #primary domain registered
#     sub_domain_name = "trv", #subdomain name
#     comments = "travelers node dns name resolutions"
#     }

#     app_cluster_name              = module.aws_resources.app_cluster_name

#     blk_cluster_name              = module.aws_resources.blk_cluster_name

#     bastion_host_nlb_external = "true"

#     terraform_state_s3_bucket_name = "openidl-backend-resources-state-files-offline-umtotr"
# }