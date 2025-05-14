#!/bin/bash
echo "[U-42] 최신 보안패치 및 벤더 권고사항 적용 여부"
if [ -x "$(command -v yum)" ]; then
    yum check-update > /dev/null
    if [ $? -eq 100 ]; then
        echo "결과: 취약 (보안 패치가 누락됨)"
    else
        echo "결과: 양호 (최신 보안 패치 적용됨)"
    fi
elif [ -x "$(command -v apt)" ]; then
    apt update > /dev/null
    UPGRADABLE=$(apt list --upgradable 2>/dev/null | grep -v "Listing..." | wc -l)
    if [ "$UPGRADABLE" -gt 0 ]; then
        echo "결과: 취약 (보안 패치가 누락됨)"
    else
        echo "결과: 양호 (최신 보안 패치 적용됨)"
    fi
else
    echo "지원되지 않는 패키지 관리자"
fi
