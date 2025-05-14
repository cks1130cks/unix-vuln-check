#!/bin/bash
echo "[U-45] root 계정 su 제한"
PERM=$(ls -l /usr/bin/su | awk '{print $1}')
if [[ "$PERM" == "-rwsr-x---" ]]; then
    echo "결과: 양호 (su 명령 제한 설정 완료)"
else
    echo "결과: 취약 (su 명령어 권한 설정 미흡)"
fi
