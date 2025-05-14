#!/bin/bash
echo "[U-47] 패스워드 최대 사용기간 설정"
if grep -q '^PASS_MAX_DAYS[[:space:]]\+90' /etc/login.defs; then
    echo "결과: 양호 (최대 사용기간 90일 이하로 설정됨)"
else
    echo "결과: 취약 (최대 사용기간 설정 없음 또는 90일 초과)"
fi
