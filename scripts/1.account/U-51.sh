#!/bin/bash

echo "U-51: 불필요한 그룹 존재 여부 점검"

GROUP_FILE="/etc/group"
echo "  점검 파일: $GROUP_FILE"

# 허용 그룹 리스트 (필요에 따라 추가/수정 가능)
ALLOWED_GROUPS=(
  "root" "bin" "daemon" "sys" "adm" "wheel" "tty" "disk" "lp" "mail" "news" "uucp"
  "man" "proxy" "kmem" "dip" "www-data" "backup" "operator" "list" "irc" "gnats"
  "shadow" "utmp" "video" "games" "users" "nogroup"
  "mem" "cdrom" "dialout" "floppy" "tape" "ftp" "lock" "audio" "nobody" "utempter"
  "avahi-autoipd" "ssh_keys" "input" "systemd-journal" "systemd-bus-proxy" "systemd-network"
  "dbus" "polkitd" "tss" "postdrop" "postfix" "sshd" "rpc" "rpcuser" "nfsnobody"
  "saslauth" "mailnull" "smmsp" "apache" "wins"
)

result="양호"

while IFS=: read -r group_name _; do
    if [[ ! " ${ALLOWED_GROUPS[*]} " =~ " ${group_name} " ]]; then
        echo "  [취약] 불필요한 그룹 발견: $group_name"
        result="취약"
    fi
done < "$GROUP_FILE"


if [ "$result" = "취약" ]; then
  echo "  참고: 불필요한 그룹은 시스템 보안 및 관리 복잡도를 증가시킬 수 있습니다."
  echo "       필요한 그룹만 유지하고, 사용하지 않는 그룹은 삭제하는 것이 권장됩니다."
fi
