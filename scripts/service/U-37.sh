#!/bin/bash
echo "[U-37] AllowOverride 설정 확인"
if grep -R '<Directory' /etc/httpd 2>/dev/null | grep -q 'AllowOverride None'; then
    echo "결과: 취약 (AllowOverride None 설정 존재)"
else
    echo "결과: 양호 (AuthConfig 설정 존재)"
fi
