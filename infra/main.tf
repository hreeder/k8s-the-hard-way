provider "google" {
  project = "${var.gcp_project}"
}

terraform {
  backend "gcs" {
    bucket = "hreeder-k8s-hard-way-state"
  }
}

module "network" {
  source = "./network"
}
