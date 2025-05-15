#!/bin/bash

echo "U-42: 최신 보안패치 및 벤더 권고사항 적용 여부"

# yum 패키지 관리자 확인 및 업데이트 점검 (RedHat 계열)
if [ -x "$(command -v yum)" ]; then
    echo "  [정보] yum 패키지 관리자 감지됨. 업데이트 상태 점검 중..."
    yum check-update > /tmp/yum_check_update.log 2>&1
    status=$?
    if [ $status -eq 100 ]; then
        echo "  [취약] 보안 패치가 누락된 패키지가 존재합니다. (최대 10개 항목 표시)"
        echo "  -- 미적용 업데이트 목록 --"
        head -n 10 /tmp/yum_check_update.log
    elif [ $status -eq 0 ]; then
        echo "  [양호] 최신 보안 패치가 모두 적용되어 있습니다."
    else
        echo "  [경고] yum check-update 실행 중 오류 발생 (종료 코드: $status)"
        echo "  -- 로그 내용 (최대 10개 항목) --"
        head -n 10 /tmp/yum_check_update.log
    fi
    rm -f /tmp/yum_check_update.log

# apt 패키지 관리자 확인 및 업데이트 점검 (Debian 계열)
elif [ -x "$(command -v apt)" ]; then
    echo "  [정보] apt 패키지 관리자 감지됨. 업데이트 상태 점검 중..."
    apt update -qq > /dev/null 2>&1
    UPGRADABLE=$(apt list --upgradable 2>/dev/null | grep -v "Listing..." | wc -l)
    if [ "$UPGRADABLE" -gt 0 ]; then
        echo "  [취약] 보안 패치가 누락된 패키지가 $UPGRADABLE 개 존재합니다. (최대 10개 항목 표시)"
        echo "  -- 미적용 업데이트 목록 --"
        apt list --upgradable 2>/dev/null | grep -v "Listing..." | head -n 10
    else
        echo "  [양호] 최신 보안 패치가 모두 적용되어 있습니다."
    fi

else
    echo "  [취약] 지원되지 않는 패키지 관리자입니다."
fi
