data "mgc_kubernetes_cluster_kubeconfig" "cluster" {
  depends_on = [mgc_kubernetes_nodepool.gp1_small]
  cluster_id = output.cluster_id
}

resource "local_file" "kubeconfig" {
  provider = local
  content  = data.mgc_kubernetes_cluster_kubeconfig.cluster.kubeconfig
  filename = "${path.module}/kubeconfig.yaml"
}
