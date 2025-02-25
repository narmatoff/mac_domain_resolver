# Задайте локальный шлюз, обычно это IP вашего маршрутизатора
# Получите локальный шлюз автоматически
LOCAL_GATEWAY=$(netstat -rn | awk '/^default/ {print $2}' | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | head -n 1)

EXCLUDED_DOMAINS=(
  "telegra.ph"
  "auth.iam.sbercloud.ru"
  "iam.sbercloud.ru"
  "cloud.domrf.ru"
  "sbercloud.ru"
  "github.com"
  "ghcr.io"
  "plus.yandex.ru"
  "synergy.ru"
  "lms.synergy.ru"
  "domrf.ru"
  "dev-vpn.domrf.ru"
  "mp.apps.k8s.dev.domoy.ru"
  "xn--80az8a.xn--d1aqf.xn--p1ai"
  "wiki.domrf.ru"
  "gitlab.ahml.ru"
  "jira.domrf.ru"
  "bitwarden.dev.domoy.ru"
  "dev.domoy.ru"
  "ahml.ru"
  "www.speedtest.net"
  "speedtest.net"
  "beget.com"
  "2ip.ru"
  "2ip.io"
  "ya.ru"
  "yandex.ru"
  "id.domrf.ru"
  "ctx.domrf.ru"
  "disk.yandex.ru"
  "feed.p5s.ru"
  "p5s.ru"
  "stripmag.ru"
  "avito.ru"
  "ozon.ru"
)

EXCLUDED_IPS=(
  "31.128.38.77"
  "195.238.250.52"
  "195.201.201.32"
  "77.88.55.242"
  "185.169.155.189"
  "5.255.255.242"
)

# Вывод локального шлюза (для проверки)
echo "Local Gateway: $LOCAL_GATEWAY"
