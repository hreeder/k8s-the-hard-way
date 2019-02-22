resource "google_compute_instance" "controller" {
  count = "${var.controllers}"

  name         = "controller-${count.index}"
  machine_type = "n1-standard-1"

  can_ip_forward = true

  tags = [
    "kubernetes-the-hard-way",
    "controller",
  ]

  boot_disk {
    initialize_params {
      size  = 200
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }

  network_interface {
    subnetwork = "${var.subnet}"
    network_ip = "10.240.0.1${count.index}"
  }
}

resource "google_compute_instance" "worker" {
  count = "${var.workers}"

  name         = "worker-${count.index}"
  machine_type = "n1-standard-1"

  can_ip_forward = true

  tags = [
    "kubernetes-the-hard-way",
    "worker",
  ]

  boot_disk {
    initialize_params {
      size  = 200
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }

  network_interface {
    subnetwork = "${var.subnet}"
    network_ip = "10.240.0.2${count.index}"
  }

  metadata = {
    pod-cidr = "10.200.${count.index}.0/24"
  }

  service_account {
    scopes = [
      "compute-rw",
      "storage-ro",
      "service-management",
      "service-control",
      "logging-write",
      "monitoring",
    ]
  }
}
