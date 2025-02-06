locals {
  zones = [
    "asia-northeast1-a",
    "asia-northeast1-b",
    "asia-northeast1-c"
  ]
}

resource "google_compute_instance" "bastion" {
  count = 2

  name         = "bastion-${count.index + 1}"
  machine_type = "e2-micro"
  zone         = local.zones[count.index]
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }
  network_interface {
    network = "default"
  }
}
