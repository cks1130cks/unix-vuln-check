#!/bin/bash
echo "[U-39] FollowSymLinks 설정 확인"
if grep -R "Options" /etc/httpd 2>/dev/null | grep -q 'FollowSymLinks'; then
    echo "결과: 취약 (FollowSymLinks 설정 존재)"
else
    echo "결과: 양호 (FollowSymLinks 설정 없음)"
fi
