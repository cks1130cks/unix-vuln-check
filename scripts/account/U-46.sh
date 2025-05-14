#!/bin/bash
echo "U-46: 패스워드 최소 길이 설정"
if grep -q '^PASS_MIN_LEN[[:space:]]\+[89]' /etc/login.defs; then
    echo "  [양호] (패스워드 최소 길이 8자 이상 설정됨)"
else
    echo "  [취약] (패스워드 최소 길이 설정 없음 또는 8자 미만)"
fi
