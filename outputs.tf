output "gke_cluster_id" {
  value = google_container_cluster.primary.id
}

output "gke_cluster_name" {
  value = google_container_cluster.primary.name
}

output "gke_cluster_node_pool_id" {
  value = google_container_node_pool.primary_nodes.id
}

output "gke_cluster_endpoint" {
  value = google_container_cluster.primary.endpoint
}