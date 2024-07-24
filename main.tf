# Create a Cluster with nodepool
resource "mgc_kubernetes_cluster" "cluster_with_nodepool" {
  name                 = var.cluster_name
  enabled_bastion      = false
  version              = var.kubernetes_version
  enabled_server_group = false
  description          = var.cluster_description
  node_pools = [{
    name     = var.nodepool_name
    replicas = var.nodepool_replicas
    flavor   = var.nodepool_flavor
  }]
}

# Set a timer to wait for the cluster to become active before creating node pools.
# We acknowledge that this is not the optimal approach and are working to improve this behavior.
resource "time_sleep" "wait_15_minutes" {
  depends_on      = [mgc_kubernetes_cluster.cluster_with_nodepool]
  create_duration = var.timer_duration
}

# Create a Nodepool
resource "mgc_kubernetes_nodepool" "gp1_small" {
  depends_on = [time_sleep.wait_15_minutes] # Wait timer
  name       = "apis-2cpu-4gb-20gb"
  cluster_id = mgc_kubernetes_cluster.cluster_with_nodepool.id
  flavor     = var.nodepool_flavor
  replicas   = var.nodepool_replicas
  auto_scale = {
    min_replicas = 1
    max_replicas = 3
  }
}
