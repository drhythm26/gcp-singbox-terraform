output "hk_node_link" {
  value = "vless://${var.uuid}@${google_compute_instance.hk_node.network_interface[0].access_config[0].nat_ip}:443?security=reality&sni=www.apple.com&fp=chrome&pbk=${var.reality_public_key}&sid=${var.short_id}&flow=xtls-rprx-vision&type=tcp#HK"
}
output "sg_node_link" {
  value = "vless://${var.uuid}@${google_compute_instance.sg_node.network_interface[0].access_config[0].nat_ip}:443?security=reality&sni=www.apple.com&fp=chrome&pbk=${var.reality_public_key}&sid=${var.short_id}&flow=xtls-rprx-vision&type=tcp#SG"
}
output "client_outbounds_json" {
  value = jsonencode({
    outbounds = [
    {
      type        = "vless"
      tag         = "hk-reality"
      server      = google_compute_instance.hk_node.network_interface[0].access_config[0].nat_ip
      server_port = 443
      uuid        = var.uuid
      flow        = "xtls-rprx-vision"
      tls = {
        enabled     = true
        server_name = "www.apple.com"
        utls = {
          enabled     = true
          fingerprint = "chrome"
        }
        reality = {
          enabled    = true
          public_key = var.reality_public_key
          short_id   = var.short_id
        }
      }
    },
    {
      type        = "vless"
      tag         = "sg-reality"
      server      = google_compute_instance.sg_node.network_interface[0].access_config[0].nat_ip
      server_port = 443
      uuid        = var.uuid
      flow        = "xtls-rprx-vision"
      tls = {
        enabled     = true
        server_name = "www.apple.com"
        utls = {
          enabled     = true
          fingerprint = "chrome"
        }
        reality = {
          enabled    = true
          public_key = var.reality_public_key
          short_id   = var.short_id
        }
      }
    }
  ]
  })
}