provider "google" {
  project = "${var.gcp_project}"
  zone    = "${var.zone}"
}

terraform {
  backend "gcs" {
    bucket = "hreeder-k8s-hard-way-state"
  }
}

module "network" {
  source = "./network"

  region = "${var.region}"
}
