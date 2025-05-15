#!/bin/bash
echo "U-44: root 이외의 UID가 0인 계정 존재 여부"
ROOTLIKE_USERS=$(awk -F: '$3 == 0 && $1 != "root" {print $1}' /etc/passwd)
if [ -n "$ROOTLIKE_USERS" ]; then
    echo "  [취약] (root 외 UID=0 계정 존재: $ROOTLIKE_USERS)"
else
    echo "  [양호] (root 외 UID=0 계정 없음)"
fi
