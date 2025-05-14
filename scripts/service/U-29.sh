#!/bin/bash
echo "U-29: tftp, talk 서비스 비활성화 점검"

# tftp 또는 talk 서비스가 활성화되어 있는지 확인
if systemctl list-units --type=service | grep -E "tftp|talk" > /dev/null; then
    echo "  [취약] tftp 또는 talk 서비스가 활성화됨"
else
    echo "  [양호] tftp, talk 서비스가 비활성화됨"
fi
