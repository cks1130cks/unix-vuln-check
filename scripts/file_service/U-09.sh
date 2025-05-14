#!/bin/bash

echo "U-09: /etc/hosts 권한 점검"

hosts_perm=$(stat -c %a /etc/hosts)
hosts_owner=$(stat -c %U /etc/hosts)

if [ "$hosts_perm" -le 600 ] && [ "$hosts_owner" = "root" ]; then
    echo "  [양호] /etc/hosts 권한 및 소유자 설정 적절."
else
    echo "  [취약] /etc/hosts 권한 또는 소유자 설정 미흡. (권한: $hosts_perm, 소유자: $hosts_owner)"
fi
