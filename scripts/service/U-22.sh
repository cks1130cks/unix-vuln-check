#!/bin/bash
echo "[U-22] root 이외의 UID 0 금지"
ROOTLIKE=$(awk -F: '$3 == 0 && $1 != "root" {print $1}' /etc/passwd)
if [ -z "$ROOTLIKE" ]; then
    echo "결과: 양호 (UID 0 계정은 root뿐)"
else
    echo "결과: 취약 (추가 UID 0 계정 존재: $ROOTLIKE)"
fi
