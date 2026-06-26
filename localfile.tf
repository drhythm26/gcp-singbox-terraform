resource "local_file" "outbounds" {
    filename = pathexpand("OUTPUT_FILE")
    content = templatefile("${path.module}/templates/outbounds.json", {
        server_sg = google_compute_instance.sg_node.network_interface[0].access_config[0].nat_ip
        server_hk = google_compute_instance.hk_node.network_interface[0].access_config[0].nat_ip
        uuid = var.uuid
        public_key = var.reality_public_key
        short_id = var.short_id
    })
}