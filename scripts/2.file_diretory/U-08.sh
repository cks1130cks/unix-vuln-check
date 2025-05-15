#!/bin/bash

echo "U-08: /etc/shadow 권한 점검"

shadow_perm=$(stat -c %a /etc/shadow)
shadow_owner=$(stat -c %U /etc/shadow)

if [ "$shadow_perm" -eq 400 ] && [ "$shadow_owner" = "root" ]; then
    echo "  [양호] /etc/shadow 권한 및 소유자 설정 적절."
else
    echo "  [취약] /etc/shadow 권한 또는 소유자 설정 미흡. (권한: $shadow_perm, 소유자: $shadow_owner)"
fi
