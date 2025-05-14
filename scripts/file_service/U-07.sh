#!/bin/bash

echo "U-07: /etc/passwd 권한 점검"

passwd_perm=$(stat -c %a /etc/passwd)
passwd_owner=$(stat -c %U /etc/passwd)

if [ "$passwd_perm" -eq 644 ] && [ "$passwd_owner" = "root" ]; then
    echo "  [양호] /etc/passwd 권한 및 소유자 설정 적절."
else
    echo "  [취약] /etc/passwd 권한 또는 소유자 설정 미흡. (권한: $passwd_perm, 소유자: $passwd_owner)"
fi
