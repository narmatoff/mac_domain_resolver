#!/bin/bash

source ./const.sh

echo "# === Добавление маршрутов в обход WireGuard ==="

# Получаем основной шлюз, если не указан
if [ -z "$LOCAL_GATEWAY" ]; then
  LOCAL_GATEWAY=$(route -n get default | awk '/gateway/ {print $2}')
fi

echo "# Используется шлюз: $LOCAL_GATEWAY"

# Удаляем возможные старые маршруты
function safe_route_add() {
  local target="$1"
  sudo route -n delete "$target" 2>/dev/null
  sudo route -n add "$target" "$LOCAL_GATEWAY"
}

# Подсети (Cisco AnyConnect) — исключаем из VPN
for SUBNET in "${STATIC_ROUTES[@]}"; do
  echo "Добавление маршрута для подсети $SUBNET (Cisco)"
  safe_route_add -net "$SUBNET"
done

# IP-адреса — исключаем из VPN
for IP in "${EXCLUDED_IPS[@]}"; do
  echo "Добавление маршрута для IP $IP"
  safe_route_add -host "$IP"
done

# Доменные имена — резолвим и исключаем
for DOMAIN in "${EXCLUDED_DOMAINS[@]}"; do
  echo "Резолвим $DOMAIN..."
  dig +short "$DOMAIN" | grep -E '^[0-9.]+' | sort -u | while read -r IP; do
    echo "Добавление маршрута для $DOMAIN ($IP)"
    safe_route_add -host "$IP"
  done
done
