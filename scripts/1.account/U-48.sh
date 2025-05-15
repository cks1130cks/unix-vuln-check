#!/bin/bash
echo "U-48: 패스워드 최소 사용기간 설정"
if grep -q '^PASS_MIN_DAYS[[:space:]]\+[1-9]' /etc/login.defs; then
    echo "  [양호] (최소 사용기간 1일 이상으로 설정됨)"
else
    echo "  [취약] (최소 사용기간 미설정 또는 0)"
fi
