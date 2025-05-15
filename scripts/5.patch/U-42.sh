#!/bin/bash

echo "U-42: 최신 보안패치 및 벤더 권고사항 적용 여부"

# yum 패키지 관리자 확인 및 업데이트 점검 (RedHat 계열)
if [ -x "$(command -v yum)" ]; then
    yum check-update > /dev/null 2>&1
    status=$?
    if [ $status -eq 100 ]; then
        echo "  [취약] (보안 패치가 누락됨)"
    elif [ $status -eq 0 ]; then
        echo "  [양호] (최신 보안 패치가 적용됨)"
    else
        echo "  [정보] yum check-update 실행 중 문제가 발생함 (종료 코드: $status)"
    fi

# apt 패키지 관리자 확인 및 업데이트 점검 (Debian 계열)
elif [ -x "$(command -v apt)" ]; then
    apt update -qq > /dev/null 2>&1
    UPGRADABLE=$(apt list --upgradable 2>/dev/null | grep -v "Listing..." | wc -l)
    if [ "$UPGRADABLE" -gt 0 ]; then
        echo "  [취약] (보안 패치가 누락됨)"
    else
        echo "  [양호] (최신 보안 패치가 적용됨)"
    fi

else
    echo "  [취약] 지원되지 않는 패키지 관리자입니다."
fi
