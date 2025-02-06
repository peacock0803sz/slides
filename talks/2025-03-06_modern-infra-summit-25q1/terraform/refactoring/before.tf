locals {
  bastions = {
    "bastion-1" = { zone = "asia-northeast1-b" }
  }
}

resource "google_compute_instance" "default" {
  for_each = local.bastions

  name         = each.key
  zone         = each.value.zone
  machine_type = "e2-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }
  network_interface {
    network = "default"
  }
}
