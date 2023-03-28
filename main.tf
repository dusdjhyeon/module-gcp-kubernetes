provider "google" {
  region = var.region
}

resource "google_container_cluster" "primary" {
  name                     = "${var.project_id}-gke"
  project                  = var.project_id
  location                 = var.region
  min_master_version       = "1.23"
  remove_default_node_pool = true
  initial_node_count       = 1
  network                  = var.vpc_name
  subnetwork               = var.subnet_id
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "${google_container_cluster.primary.name}-node-pool"
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = var.gke_num_nodes
  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels = {
      env = var.project_id
    }

    machine_type = var.gke_machine_type
    tags         = ["gke-node", "${var.project_id}-gke"]

    metadata = {
      disable-legacy-endpoints = "true"
      namespace                = var.gke_namespace
    }
  }
}

resource "local_file" "kubeconfig" {
  content  = <<-KUBECONFIG_END
  apiVersion: v1
  clusters:
  - cluster:
      certificate-authority-data: ${google_container_cluster.primary.master_auth[0].cluster_ca_certificate}
      server: ${google_container_cluster.primary.endpoint}
    name: ${google_container_cluster.primary.name}
  contexts:
  - context:
      cluster: ${google_container_cluster.primary.name}
      user: ${google_container_cluster.primary.name}
    name: ${google_container_cluster.primary.name}
  current-context: ${google_container_cluster.primary.name}
  kind: Config
  preferences: {}
  users:
  - name: ${google_container_cluster.primary.name}
    user:
      auth-provider:
        config:
          access-token: ${var.google_client_access_token}
          cmd-args: config config-helper --format=json
          cmd-path: gcloud
          expiry-key: '{.credential.token_expiry}'
          token-key: '{.credential.access_token}'
        name: gcp
    KUBECONFIG_END
  filename = "kubeconfig.yaml"
}