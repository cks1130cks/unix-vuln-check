#!/bin/bash
echo "U-25: 장기간 미사용 계정 점검"

# 마지막 로그인 기록이 없는 계정 추출 (lastlog 기준)
INACTIVE_USERS=$(lastlog | awk '$4=="**Never" && $1 != "Username" {print $1}')

if [ -n "$INACTIVE_USERS" ]; then
    echo "  [취약] 장기간 미사용 계정 존재:"
    echo "    $INACTIVE_USERS"
else
    echo "  [양호] 장기간 미사용 계정이 존재하지 않음"
fi
