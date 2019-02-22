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
}

module "compute" {
  source = "./compute"

  controllers = "3"
  workers     = "3"
  subnet      = "${module.network.subnet_name}"
}
