#!/bin/bash

# Подключаем переменные
source ./const.sh

echo "# Local Gateway: $LOCAL_GATEWAY"
echo "# === Генерация маршрутов для доменов `wireguard-tools` (`wg-quick`) ==="

# Обрабатываем домены
for DOMAIN in "${EXCLUDED_DOMAINS[@]}"; do
  echo "# $DOMAIN"
  dig +short "$DOMAIN" | grep -E '^[0-9.]+' | sort -u | while read -r IP; do
    echo "PostUp = route -n add $IP/32 $LOCAL_GATEWAY"
    echo "PostDown = route -n delete $IP/32 $LOCAL_GATEWAY"
  done
done

echo "# === Генерация маршрутов для IP ==="
for IP in "${EXCLUDED_IPS[@]}"; do
  echo "PostUp = route -n add $IP/32 $LOCAL_GATEWAY"
  echo "PostDown = route -n delete $IP/32 $LOCAL_GATEWAY"
done
