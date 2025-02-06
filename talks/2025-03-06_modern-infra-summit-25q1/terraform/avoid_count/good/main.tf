locals {
  bastions = {
    "bastion-1" = { zone = "asia-northeast1-b" }
    "bastion-2" = { zone = "asia-northeast1-c" }
    // 同様に bastion-2, bastion-3 も定義する
  }
}

resource "google_compute_instance" "bastion" {
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
