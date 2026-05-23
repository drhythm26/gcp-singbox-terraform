#!/bin/bash

set -eu

install_docker() {
    
    apt update -qq
    apt install -yqq ca-certificates curl
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
    chmod a+r /etc/apt/keyrings/docker.asc

    tee /etc/apt/sources.list.d/docker.sources >/dev/null <<EOF
Types: deb
URIs: https://download.docker.com/linux/debian
Suites: $(. /etc/os-release && echo "$VERSION_CODENAME")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

    apt update -qq
    apt install -yqq docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

}

generate_config() {
    mkdir -p /etc/sing-box
    tee /etc/sing-box/config.json >/dev/null << 'JSON'
${config_json}
JSON
}

generate_docker_compose() {
    tee /etc/sing-box/docker-compose.yml >/dev/null << 'YAML'
services:
  sing-box:
    container_name: sing-box
    image: ghcr.io/sagernet/sing-box
    network_mode: host
    restart: unless-stopped
    volumes:
      - /etc/sing-box:/etc/sing-box
    command: ['run', '-D', '/var/lib/sing-box', '-C', '/etc/sing-box']
YAML
    docker compose -f /etc/sing-box/docker-compose.yml up -d
}

main() {
    install_docker
    generate_config
    generate_docker_compose
}

main "$@"