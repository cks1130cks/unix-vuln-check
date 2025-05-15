#!/bin/bash

echo "U-37: AllowOverride 설정 확인"
echo "  점검 대상: /etc/httpd 내 <Directory> 설정"

# /etc/httpd 하위에서 <Directory>와 AllowOverride None이 같이 포함된 부분을 점검
if grep -R '<Directory' /etc/httpd 2>/dev/null | grep -q 'AllowOverride None'; then
    echo "  [취약] AllowOverride None 설정이 존재합니다."
else
    echo "  [양호] AllowOverride None 설정이 존재하지 않습니다."
fi
