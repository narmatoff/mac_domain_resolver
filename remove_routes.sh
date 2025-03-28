#!/bin/bash

# Импортируем константы из файла config.sh
source "$(dirname "$0")/const.sh"

# Функция для разрешения доменных имен в IP-адреса
resolve_domain() {
  DOMAIN=$1
  IP=$(dig +short $DOMAIN | grep -E '^[0-9]+(\.[0-9]+){3}$' | tail -n 1)
  if [[ -n $IP ]]; then
    echo $IP
  else
    echo "Ошибка: не удалось разрешить домен $DOMAIN" >&2
    return 1
  fi
}

echo "====================================================="
echo "=============Определение IP-адреса==================="
echo "====================================================="

# Разрешение доменных имен в IP-адреса
for DOMAIN in "${EXCLUDED_DOMAINS[@]}"; do
  IP=$(resolve_domain $DOMAIN)
  if [[ $? -eq 0 ]]; then
    EXCLUDED_IPS+=("$IP")
    echo "$DOMAIN ==>> $IP"
  fi
done

echo "====================================================="
echo "================Удаление роутов======================"
echo "====================================================="

# Удаление маршрутов для исключения IP из VPN
for IP in "${EXCLUDED_IPS[@]}"; do
  # Проверка на существующий маршрут
  if netstat -rn | grep -q "$IP"; then
    sudo route -n delete $IP
    if [[ $? -eq 0 ]]; then
      echo "Удален маршрут для $IP"
    else
      echo "Ошибка: не удалось удалить маршрут для $IP" >&2
    fi
  else
    echo "Маршрут для $IP не найден или уже удален"
  fi
done
