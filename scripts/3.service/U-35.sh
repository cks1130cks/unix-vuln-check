#!/bin/bash
echo "U-35: 디렉터리 리스팅 설정 확인"
if grep -R "Options" /etc/httpd 2>/dev/null | grep -q 'Indexes'; then
    echo "  [취약] (Indexes 설정 존재)"
else
    echo "  [양호] (Indexes 설정 없음)"
fi
