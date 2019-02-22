resource "google_compute_network" "default" {
  name                    = "k8s-the-hard-way"
  auto_create_subnetworks = false
}
