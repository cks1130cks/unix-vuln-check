#!/bin/bash
echo "[U-21] 패스워드 파일 암호화 저장"
if [ "$(stat -c %a /etc/shadow 2>/dev/null)" == "000" ] || [ "$(stat -c %a /etc/shadow 2>/dev/null)" == "400" ]; then
    echo "결과: 양호 (/etc/shadow 접근 제한됨)"
else
    echo "결과: 취약 (/etc/shadow 권한이 과도함)"
fi
