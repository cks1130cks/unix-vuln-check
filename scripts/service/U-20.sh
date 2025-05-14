#!/bin/bash
echo "[U-20] 패스워드 파일 보호"
if [ "$(stat -c %a /etc/passwd)" -le 644 ]; then
    echo "결과: 양호 (/etc/passwd 권한 적절)"
else
    echo "결과: 취약 (/etc/passwd 권한 과도함)"
fi
