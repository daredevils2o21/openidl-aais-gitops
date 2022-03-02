#Define required providers configuration
provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  assume_role {
    role_arn     = var.aws_role_arn
    session_name = "terraform-session"
    external_id  = var.aws_external_id
  }
}


# provider "aws" {
#   region     = var.aws_region
#   assume_role {
#     role_arn     = "arn:aws:iam::${var.awsAccountId}:role/travrol-eng-tfe"
#     session_name = "tfe@travelers.com"
#     external_id  = var.aws_external_id
#   }
# }

provider "kubernetes" {
  alias                  = "app_cluster"
  host                   = data.aws_eks_cluster.app_eks_cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.app_eks_cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.app_eks_cluster_auth.token
   exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
     args        = ["eks", "get-token", "--cluster-name", "${local.app_cluster_name}"]
    command     = "aws"
   }

}
#provider for blockchain cluster (kubernetes)
provider "kubernetes" {
  alias                  = "blk_cluster"
  host                   = data.aws_eks_cluster.blk_eks_cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.blk_eks_cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.blk_eks_cluster_auth.token
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
     args        = ["eks", "get-token", "--cluster-name", "${local.blk_cluster_name}"]
    command     = "aws"
  }
}
#provider for application cluster (helm)
provider "helm" {
  alias = "app_cluster"
  kubernetes {
    host                   = data.aws_eks_cluster.app_eks_cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.app_eks_cluster.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.app_eks_cluster_auth.token
   exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    args        = ["eks", "get-token", "--cluster-name", "${local.app_cluster_name}"]
    command     = "aws"
   }
  }
}
#provider for application cluster (helm)
provider "helm" {
  alias = "blk_cluster"
  kubernetes {
    host                   = data.aws_eks_cluster.blk_eks_cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.blk_eks_cluster.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.blk_eks_cluster_auth.token
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["eks", "get-token", "--cluster-name", "${local.blk_cluster_name}"]
      command     = "aws"
  }
  }
}
