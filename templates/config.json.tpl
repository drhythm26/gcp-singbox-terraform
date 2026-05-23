{
  "inbounds": [
    {
      "type": "vless",
      "listen": "::",
      "listen_port": 443,
      "users": [
        {
          "uuid": "${uuid}",
          "flow": "xtls-rprx-vision"
        }
      ],
      "tls": {
        "enabled": true,
        "server_name": "www.apple.com",
        "reality": {
          "enabled": true,
          "handshake": {
            "server": "www.apple.com",
            "server_port": 443
          },
          "private_key": "${reality_private_key}",
          "short_id": ["${short_id}"]
        }
      }
    }
  ],
  "outbounds": [
    { "type": "direct", "tag": "direct" }
  ]
}