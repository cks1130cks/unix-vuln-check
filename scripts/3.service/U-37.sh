#!/bin/bash

echo "U-37: AllowOverride 설정 확인"
echo "  점검 대상: /etc/httpd 내 <Directory> 설정"

if grep -Ri '<Directory' /etc/httpd 2>/dev/null | grep -i 'AllowOverride' | grep -iwq 'none'; then
    echo "  [취약] AllowOverride None 설정이 존재합니다."
else
    echo "  [양호] AllowOverride None 설정이 존재하지 않습니다."
fi
