#!/bin/bash
echo "[U-29] tftp, talk 서비스 비활성화"
if systemctl list-units --type=service | grep -E "tftp|talk" > /dev/null; then
    echo "결과: 취약 (tftp 또는 talk 서비스 활성화)"
else
    echo "결과: 양호 (tftp, talk 비활성화)"
fi
