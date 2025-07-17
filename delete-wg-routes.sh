#!/bin/bash

source ./const.sh

echo "# === Удаление маршрутов, исключённых из WireGuard ==="

# Удаляем маршруты для подсетей (Cisco AnyConnect)
for SUBNET in "${STATIC_ROUTES[@]}"; do
  echo "Удаление маршрута для подсети $SUBNET"
  sudo route -n delete -net "$SUBNET" 2>/dev/null
done

# Удаляем маршруты для IP
for IP in "${EXCLUDED_IPS[@]}"; do
  echo "Удаление маршрута для IP $IP"
  sudo route -n delete -host "$IP" 2>/dev/null
done

# Удаляем маршруты для резолвленных доменов
for DOMAIN in "${EXCLUDED_DOMAINS[@]}"; do
  echo "Резолвим $DOMAIN..."
  dig +short "$DOMAIN" | grep -E '^[0-9.]+' | sort -u | while read -r IP; do
    echo "Удаление маршрута для $DOMAIN ($IP)"
    sudo route -n delete -host "$IP" 2>/dev/null
  done
done
