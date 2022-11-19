terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.6.0"
    }
  }
}

resource "google_service_account" "default" {
  account_id   = var.account_id
  display_name = var.display_name
}

provider "google" {
  project = var.project_id
}



resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.cluster_location

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = var.node_name
  location   = var.node_location
  cluster    = google_container_cluster.primary.name
  node_count = var.node_count

  node_config {
    preemptible  = true
    machine_type = var.machine_type

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = google_service_account.default.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

module "gke_auth" {
  source = "terraform-google-modules/kubernetes-engine/google//modules/auth"

  project_id           = var.project_id
  cluster_name         = var.cluster_name
  location             = var.cluster_location
  use_private_endpoint = true
}

resource "local_file" "kubeconfig" {
  content  = module.gke_auth.kubeconfig_raw
  filename = "${path.module}/kubeconfig"
  #Cria o arquivo kubeconfig com a conexão com  cluster
}
