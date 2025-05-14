#!/bin/bash
echo "[U-34] DNS Zone Transfer 제한 설정 확인"
ZONE_FILE=$(find / -name named.conf 2>/dev/null | head -n 1)
if [ -n "$ZONE_FILE" ]; then
    if grep -q 'allow-transfer' "$ZONE_FILE"; then
        echo "결과: 양호 (allow-transfer 설정 존재)"
    else
        echo "결과: 취약 (allow-transfer 설정 없음)"
    fi
else
    echo "named.conf 파일 없음 - 대상 아님"
fi
