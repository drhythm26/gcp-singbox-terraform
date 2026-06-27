resource "google_service_account" "singbox_node" {
  account_id   = "singbox-node"
  display_name = "Sing-box GCE node"
  project      = var.project_id
}