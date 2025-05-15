#!/bin/bash

echo "U-55: hosts.lpd 파일 소유자 및 권한 설정 점검"

file="/etc/hosts.lpd"

echo "  점검 파일: $file"

if [ -e "$file" ]; then
    owner=$(stat -c %U "$file")
    perms=$(stat -c %a "$file")

    echo "  현재 소유자: $owner"
    echo "  현재 권한: $perms"

    if [ "$owner" = "root" ] && [ "$perms" -le 640 ]; then
        echo "  [양호] 파일 소유자가 root이고 권한이 640 이하로 설정되어 있습니다."
    else
        echo "  [취약] 파일 소유자가 root가 아니거나 권한이 640 초과로 설정되어 있습니다."
    fi
else
    echo "  [양호] $file 파일이 존재하지 않습니다."
fi
