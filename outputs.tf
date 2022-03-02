

output "private_key"{
  value = tls_private_key.that.public_key_openssh
}

#-----------------------------------------------------------------------------------------------------------------
#aws cognito application client outputs
output "cognito_user_pool_id" {
  value     = module.aws_resources.cognito_user_pool_id
  sensitive = true
}

output "app_cluster_name" {
  value = module.aws_resources.app_cluster_name
}

output "blk_cluster_name" {
  value = module.aws_resources.blk_cluster_name
}

output "org_name" {
  value = module.aws_resources.org_name
}

output "aws_env" {
  value = module.aws_resources.aws_env
}

output "aws_name_servers" {
  value = module.aws_resources.aws_name_servers
}

output "r53_private_hosted_zone_internal_id" {
  value = module.aws_resources.r53_private_hosted_zone_internal_id
}

output "r53_private_hosted_zone_id" {
  value = module.aws_resources.r53_private_hosted_zone_id
}

output "baf_automation_user_arn" {
  value = module.aws_resources.baf_automation_user_arn
}

output "app_eks_nodegroup_role_arn" {
  value = module.aws_resources.app_eks_nodegroup_role_arn
}

output "eks_admin_role_arn" {
  value = module.aws_resources.eks_admin_role_arn
}

output "git_actions_admin_role_arn" {
  value = module.aws_resources.git_actions_admin_role_arn
}

output "blk_eks_nodegroup_role_arn" {
  value = module.aws_resources.blk_eks_nodegroup_role_arn
}

output "public_blk_bastion_fqdn" {
  value = module.aws_resources.public_blk_bastion_fqdn
}

output "public_app_bastion_dns_name" {
  value = module.aws_resources.public_app_bastion_dns_name
}

output "public_blk_bastion_dns_name" {
  value = module.aws_resources.public_blk_bastion_dns_name
}

output "cognito_app_client_id" {
  value = module.aws_resources.cognito_app_client_id
  sensitive = true
}
output "git_actions_iam_user_arn" {
  value = module.aws_resources.git_actions_iam_user_arn
}

output "app_cluster_endpoint" {
  value = module.aws_resources.app_cluster_endpoint
}

output "blk_cluster_endpoint" {
  value = module.aws_resources.blk_cluster_endpoint
}

output "cloudtrail_s3_bucket_name" {
  value = module.aws_resources.cloudtrail_s3_bucket_name
}

output "public_app_bastion_fqdn" {
  value = module.aws_resources.public_app_bastion_fqdn
}

output "kms_key_arn_vault_unseal_arn" {
  value = module.aws_resources.kms_key_arn_vault_unseal_arn
}

output "kms_key_id_vault_unseal_name" {
  value = module.aws_resources.kms_key_id_vault_unseal_name
}

output "r53_public_hosted_zone_id" {
  value = module.aws_resources.r53_public_hosted_zone_id
}


output "domain_info" {
  value = module.aws_resources.domain_info
}

output "bastion_host_nlb_external" {
  value = module.aws_resources.bastion_host_nlb_external
}
####EXTRA FROM AAIS UPDATED REPO
output "hds_data_s3_bucket_name" {
  value = module.aws_resources.hds_data_s3_bucket_name
}
output "s3_public_bucket_logos" {
  value = module.aws_resources.s3_public_bucket_logos_name
}
output "openidl_app_iam_user_arn" {
  value = module.aws_resources.openidl_app_iam_user_arn
}


# K8S OUTPUT
#Route53 private entries
output "private_data_call_service_fqdn" {
  value = module.k8s_resources.private_data_call_service_fqdn
}
output "private_insurance_manager_service_fqdn" {
  value = module.k8s_resources.private_insurance_manager_service_fqdn
}
output "private_vault_fqdn" {
  value = module.k8s_resources.private_vault_fqdn
}
output "private_ordererorg_fqdn" {
  value = module.k8s_resources.private_ordererorg_fqdn
}
#output "private_aais-net_fqdn" {
#  value = var.org_name == "aais" ? aws_route53_record.private_record_aais["*.aais-net.aais"].fqdn : null
#}
output "private_common_fqdn" {
  value = module.k8s_resources.private_common_fqdn
}
#Route53 public entries
output "public_app_ui_url" {
  value = module.k8s_resources.public_app_ui_url
}
output "public_ordererog_fqdn" {
  value = module.k8s_resources.public_ordererog_fqdn
}
output "public_common_fqdn" {
  value = module.k8s_resources.public_common_fqdn
}
output "public_data_call_service_fqdn" {
  value = module.k8s_resources.public_data_call_service_fqdn
}
output "public_insurance_manager_service_fqdn" {
  value = module.k8s_resources.public_insurance_manager_service_fqdn
}
output "public_utilities_service_fqdn" {
  value = module.k8s_resources.public_utilities_service_fqdn
}
output "dns_entries_required_to_update" {
  value = module.k8s_resources.dns_entries_required_to_update
}
output "dns_entries_required_to_add" {
  value = module.k8s_resources.dns_entries_required_to_add
}

#Route53 entries
output "private_app_bastion_nlb_private_fqdn" {
  value = module.k8s_resources.private_app_bastion_nlb_private_fqdn
}
output "private_blk_bastion_nlb_private_fqdn" {
  value = module.k8s_resources.private_blk_bastion_nlb_private_fqdn
}

#-----------------------------------------------------------------------------------------------------------------
#KMS key related to vault unseal
output "kms_key_arn_vault_unseal" {
  value = module.k8s_resources.kms_key_arn_vault_unseal
}
output "kms_key_id_vault_unseal" {
  value = module.k8s_resources.kms_key_id_vault_unseal
}
