#!/bin/bash
echo "U-22: root 이외의 UID 0 계정 존재 여부 점검"

# UID 0이면서 계정명이 root가 아닌 사용자 검색
ROOTLIKE=$(awk -F: '$3 == 0 && $1 != "root" {print $1}' /etc/passwd)

if [ -z "$ROOTLIKE" ]; then
    echo "  [양호] UID 0 계정은 root 하나뿐임"
else
    echo "  [취약] root 외 UID 0 계정 존재: $ROOTLIKE"
fi
