variable "account_id" {
  default = "service-account-winterfox"
}

variable "display_name" {
  default = "Winterfox-Service-Account"
}

variable "project_id" {
  default = "winterfoxit-333200"
}

variable "cluster_name" {
  default = "my-gke-cluster"
}

variable "cluster_location" {
  default = "us-central1-a"
}

variable "node_name" {
  default     = "my-node-pool"
  description = "Node pool name"
}

variable "node_location" {
  default = "us-central1-a"
}

variable "node_count" {
  default = "3"
}

variable "machine_type" {
  default = "e2-medium"
}