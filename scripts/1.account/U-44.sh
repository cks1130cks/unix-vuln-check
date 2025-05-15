#!/bin/bash
echo "U-44: root 이외의 UID가 0인 계정 존재 여부 점검"

PASSFILE="/etc/passwd"
echo "  점검 파일: $PASSFILE"

# UID 0인데 계정명이 root가 아닌 경우 추출
ROOTLIKE_USERS=$(awk -F: '$3 == 0 && $1 != "root"' "$PASSFILE")

if [ -n "$ROOTLIKE_USERS" ]; then
    echo "  [취약] root 계정 외에 UID가 0인 계정이 존재합니다."
    echo "         UID 0은 시스템 상 최고 권한을 가지므로, root 외 계정은 보안상 매우 위험합니다."
    echo "         발견된 계정:"
    echo "$ROOTLIKE_USERS" | while read user; do
        echo "           - $(echo "$user" | awk -F: '{print $1}')"
    done
else
    echo "  [양호] root 외에 UID가 0인 계정이 존재하지 않습니다."
fi
