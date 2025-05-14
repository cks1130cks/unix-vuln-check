#!/bin/bash
echo "U-39: FollowSymLinks 설정 확인"
if grep -R "Options" /etc/httpd 2>/dev/null | grep -q 'FollowSymLinks'; then
    echo "  [취약] (FollowSymLinks 설정 존재)"
else
    echo "  [양호] (FollowSymLinks 설정 없음)"
fi
