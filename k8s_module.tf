module "k8s_resources" {
    source = "./aws/k8s_resources"

    aws_region                      = var.aws_region
    org_name                        = module.aws_resources.org_name 
    aws_env                         = module.aws_resources.aws_env 

    domain_info                     = module.aws_resources.domain_info

    app_cluster_name                = module.aws_resources.app_cluster_name

    blk_cluster_name                = module.aws_resources.blk_cluster_name

    bastion_host_nlb_external       = module.aws_resources.bastion_host_nlb_external

    terraform_state_s3_bucket_name  = "openidl-backend-resources-state-files-offline-umtotr"
}
