#!/bin/bash
echo "[U-23] 계정 잠금 임계값 설정"
grep -q "deny=" /etc/pam.d/system-auth
if [ $? -eq 0 ]; then
    echo "결과: 양호 (deny 옵션 설정됨)"
else
    echo "결과: 취약 (deny 옵션 미설정)"
fi
