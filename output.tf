output "hk_node_link" {
  value = "vless://${var.uuid}@${google_compute_instance.hk_node.network_interface[0].access_config[0].nat_ip}:443?security=reality&sni=www.apple.com&fp=chrome&pbk=${var.reality_public_key}&sid=${var.short_id}&flow=xtls-rprx-vision&type=tcp#HK"
}
output "sg_node_link" {
  value = "vless://${var.uuid}@${google_compute_instance.sg_node.network_interface[0].access_config[0].nat_ip}:443?security=reality&sni=www.apple.com&fp=chrome&pbk=${var.reality_public_key}&sid=${var.short_id}&flow=xtls-rprx-vision&type=tcp#SG"
}