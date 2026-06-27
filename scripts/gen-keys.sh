#!/bin/bash
set -eu
FILE="keys.auto.tfvars"
if [[ -f "$FILE" ]]; then
  echo "密钥已存在，跳过生成：$FILE"
  exit 0
fi

realitykeypair=$(docker run --rm ghcr.io/sagernet/sing-box:1.13.14 generate reality-keypair)
publickey=$(awk '/PublicKey/ {print $2}' <<< "$realitykeypair")
privatekey=$(awk '/PrivateKey/ {print $2}' <<< "$realitykeypair")
uuid=$(docker run --rm ghcr.io/sagernet/sing-box:1.13.14 generate uuid)
shortid=$(docker run --rm ghcr.io/sagernet/sing-box:1.13.14 generate rand 8 --hex)


tee keys.auto.tfvars << EOF
reality_public_key = "$publickey"
reality_private_key = "$privatekey"
uuid = "$uuid"
short_id = "$shortid"
EOF