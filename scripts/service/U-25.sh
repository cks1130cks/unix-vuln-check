#!/bin/bash
echo "[U-25] 사용하지 않는 계정 제거"
INACTIVE_USERS=$(lastlog | awk '$4=="**Never" && $1 != "Username" {print $1}')
if [ -n "$INACTIVE_USERS" ]; then
    echo "결과: 취약 (다음 계정이 장기간 미사용 중)"
    echo "$INACTIVE_USERS"
else
    echo "결과: 양호 (장기 미사용 계정 없음)"
fi
