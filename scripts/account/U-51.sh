#!/bin/bash

echo "U-51: 불필요한 그룹 존재 여부 점검"

# 허용 그룹 리스트 (필요에 따라 수정)
ALLOWED_GROUPS=(
  "root" "bin" "daemon" "sys" "adm" "wheel" "tty" "disk" "lp" "mail" "news" "uucp"
  "man" "proxy" "kmem" "dip" "www-data" "backup" "operator" "list" "irc" "gnats"
  "shadow" "utmp" "video" "games" "users" "nogroup"
  "mem" "cdrom" "dialout" "floppy" "tape" "ftp" "lock" "audio" "nobody" "utempter"
  "avahi-autoipd" "ssh_keys" "input" "systemd-journal" "systemd-bus-proxy" "systemd-network"
  "dbus" "polkitd" "tss" "postdrop" "postfix" "sshd" "rpc" "rpcuser" "nfsnobody"
  "saslauth" "mailnull" "smmsp" "apache"
)
result="양호"
while IFS=: read -r group_name _; do
    if [[ ! " ${ALLOWED_GROUPS[*]} " =~ " ${group_name} " ]]; then
        echo "  불필요한 그룹 발견: $group_name"
        result="취약"
    fi
done < /etc/group

echo "  [$result]"
