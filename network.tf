resource "google_compute_network" "singbox_vpc" {
  name                    = "singbox-vpc"
  auto_create_subnetworks = false
  depends_on = [
    google_project_service.compute
  ]
}

resource "google_compute_subnetwork" "hk_subnet" {
  name          = "singbox-hk-subnet"
  network       = google_compute_network.singbox_vpc.id
  region        = var.hk_region
  ip_cidr_range = "10.0.1.0/24"
  depends_on = [
    google_compute_network.singbox_vpc
  ]
}

resource "google_compute_subnetwork" "sg_subnet" {
  name          = "singbox-sg-subnet"
  network       = google_compute_network.singbox_vpc.id
  region        = var.sg_region
  ip_cidr_range = "10.0.2.0/24"
  depends_on = [
    google_compute_network.singbox_vpc
  ]
}

resource "google_compute_firewall" "allow_singbox" {
  name    = "allow-singbox-443"
  network = google_compute_network.singbox_vpc.id
  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["singbox"]
  depends_on = [
    google_compute_network.singbox_vpc
  ]
}