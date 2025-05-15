#!/bin/bash

echo "U-04: 패스워드 파일 보호 점검"

passwd_file="/etc/passwd"
shadow_file="/etc/shadow"

# /etc/passwd 점검
passwd_perm=$(stat -c %a "$passwd_file")
passwd_owner=$(stat -c %U "$passwd_file")

if [ "$passwd_perm" -le 644 ] && [ "$passwd_owner" = "root" ]; then
    echo "  [양호] /etc/passwd 권한 및 소유자 적절."
else
    echo "  [취약] /etc/passwd 권한 또는 소유자 부적절 (권한: $passwd_perm, 소유자: $passwd_owner)."
fi

# /etc/shadow 점검
shadow_perm=$(stat -c %a "$shadow_file")
shadow_owner=$(stat -c %U "$shadow_file")

if [ "$shadow_perm" -le 400 ] && [ "$shadow_owner" = "root" ]; then
    echo "  [양호] /etc/shadow 권한 및 소유자 적절."
else
    echo "  [취약] /etc/shadow 권한 또는 소유자 부적절 (권한: $shadow_perm, 소유자: $shadow_owner)."
fi
