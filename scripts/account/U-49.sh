#!/bin/bash
echo "[U-49] 불필요한 계정 제거"
EXTRA_USERS=$(awk -F: '$3 >= 1000 && $1 != "nobody" && $7 != "/sbin/nologin" && $7 != "/bin/false"' /etc/passwd)
if [ -n "$EXTRA_USERS" ]; then
    echo "경고: 다음 사용자 계정이 존재합니다:"
    echo "$EXTRA_USERS"
    echo "결과: 취약 (불필요한 계정 존재 가능)"
else
    echo "결과: 양호 (불필요한 계정 없음)"
fi
