#!/bin/bash

source ./const.sh

echo "# === Добавление маршрутов ==="

for DOMAIN in "${EXCLUDED_DOMAINS[@]}"; do
  dig +short "$DOMAIN" | grep -E '^[0-9.]+' | sort -u | while read -r IP; do
    sudo route -n add "$IP/32" "$LOCAL_GATEWAY"
  done
done

for IP in "${EXCLUDED_IPS[@]}"; do
  sudo route -n add "$IP/32" "$LOCAL_GATEWAY"
done

for SUBNET in "${STATIC_ROUTES[@]}"; do
  sudo route -n add "$SUBNET" "$LOCAL_GATEWAY"
done
