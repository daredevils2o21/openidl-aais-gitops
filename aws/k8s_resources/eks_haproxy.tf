#setting up ha proxy in app cluster
resource "helm_release" "app_haproxy" {
  depends_on = [data.aws_eks_cluster.app_eks_cluster, data.aws_eks_cluster_auth.app_eks_cluster_auth, kubernetes_config_map.app_config_map]
  provider = helm.app_cluster
  cleanup_on_fail = true
  name = "haproxy-app-ingress"
  chart ="${path.module}/resources/haproxy-app-cluster"
  timeout = 6000
  force_update = false
  wait = false
  wait_for_jobs = false
  values = ["${file("${path.module}/resources/haproxy-app-cluster/values.yaml")}"]
  namespace="ingress-controller"
  create_namespace = true
}
#setting up ha proxy in blk cluster
resource "helm_release" "blk_haproxy" {
  depends_on = [data.aws_eks_cluster.blk_eks_cluster, data.aws_eks_cluster_auth.blk_eks_cluster_auth, kubernetes_config_map.blk_config_map]
  provider = helm.blk_cluster
  cleanup_on_fail = true
  name = "haproxy-blk-ingress"
  chart ="${path.module}/resources/haproxy-blk-cluster"
  timeout = 6000
  force_update = false
  wait = false
  wait_for_jobs = false
  values = ["${file("${path.module}/resources/haproxy-blk-cluster/values.yaml")}"]
  namespace="ingress-controller"
  create_namespace = true

}

# #Original not working
# resource "helm_release" "app_haproxy" {
#   depends_on = [data.aws_eks_cluster.app_eks_cluster, data.aws_eks_cluster_auth.app_eks_cluster_auth, kubernetes_config_map.app_config_map]
#   provider = helm.app_cluster
#   cleanup_on_fail = true
#   name = "haproxy-ingress"
#   chart ="${path.module}/resources/haproxy-app-cluster"
#   timeout = 600
#   force_update = true
#   wait = true
#   wait_for_jobs = true
#   values = ["${file("${path.module}/resources/haproxy-app-cluster/values.yaml")}"]
# }
# #setting up ha proxy in blk cluster
# resource "helm_release" "blk_haproxy" {
#   depends_on = [data.aws_eks_cluster.blk_eks_cluster, data.aws_eks_cluster_auth.blk_eks_cluster_auth, kubernetes_config_map.blk_config_map]
#   provider = helm.blk_cluster
#   cleanup_on_fail = true
#   name = "haproxy-ingress"
#   chart ="${path.module}/resources/haproxy-blk-cluster"
#   timeout = 600
#   force_update = true
#   wait = true
#   wait_for_jobs = true
#   values = ["${file("${path.module}/resources/haproxy-blk-cluster/values.yaml")}"]
# }