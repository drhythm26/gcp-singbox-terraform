resource "google_compute_instance" "hk_node" {
  name         = "singbox-hk-node"
  machine_type = "e2-micro"
  zone         = var.hk_zone
  tags         = ["singbox"]
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
      size  = 20
      type  = "pd-standard"
    }
  }
  network_interface {
    subnetwork = google_compute_subnetwork.hk_subnet.self_link
    access_config {
      network_tier = "PREMIUM"
    }
  }
  service_account {
    email  = google_service_account.singbox_node.email
    scopes = []
  }
  metadata_startup_script = local.startup
  depends_on = [
    google_project_service.compute,
  ]
}

resource "google_compute_instance" "sg_node" {
  name         = "singbox-sg-node"
  machine_type = "e2-micro"
  zone         = var.sg_zone
  tags         = ["singbox"]
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
      size  = 20
      type  = "pd-standard"
    }
  }
  network_interface {
    subnetwork = google_compute_subnetwork.sg_subnet.self_link
    access_config {
      network_tier = "PREMIUM"
    }
  }
  service_account {
    email  = google_service_account.singbox_node.email
    scopes = []
  }
  metadata_startup_script = local.startup
  depends_on = [
    google_project_service.compute,
  ]
}

locals {
  config = templatefile("templates/config.json.tpl", {
    uuid                = var.uuid
    reality_private_key = var.reality_private_key
    short_id            = var.short_id
  })
  startup = templatefile("templates/startscript.sh.tpl", {
    config_json = local.config
  })
}