#!/bin/bash

echo "U-34: DNS Zone Transfer 제한 설정 확인"
echo "  점검 파일: named.conf (최초 발견 파일)"

ZONE_FILE=$(find / -name named.conf 2>/dev/null | head -n 1)

if [ -n "$ZONE_FILE" ]; then
    echo "  점검 파일 경로: $ZONE_FILE"
    if grep -q 'allow-transfer' "$ZONE_FILE"; then
        echo "  [양호] named.conf에 allow-transfer 설정이 존재합니다."
        echo "  설정 내용 (일부):"
        grep 'allow-transfer' "$ZONE_FILE" | head -n 5 | sed 's/^/    /'
    else
        echo "  [취약] named.conf에 allow-transfer 설정이 없습니다."
    fi
else
    echo "  [양호] named.conf 파일이 존재하지 않아 대상이 아닙니다."
fi
