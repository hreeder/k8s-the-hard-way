resource "google_compute_network" "self" {
  name                    = "kubernetes-the-hard-way"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "self" {
  name          = "kubernetes"
  ip_cidr_range = "10.240.0.0/24"
}

resource "google_compute_firewall" "internal" {
  name = "kubernetes-the-hard-way-allow-internal"

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "udp"
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = [
    "10.240.0.0/24",
    "10.200.0.0/16",
  ]
}

resource "google_compute_firewall" "external" {
  name = "kubernetes-the-hard-way-allow-external"

  allow {
    protocol = "tcp"
    ports    = ["22", "6443"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_address" "public" {
  name   = "kubernetes-the-hard-way"
  region = "${var.region}"
}
