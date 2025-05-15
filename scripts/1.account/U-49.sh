#!/bin/bash

echo "U-49: 불필요한 계정 제거 점검"

PASSWD_FILE="/etc/passwd"

echo "  점검 파일: $PASSWD_FILE"
if [ ! -f "$PASSWD_FILE" ]; then
    echo "  [정보] /etc/passwd 파일이 존재하지 않습니다. 점검 대상이 아닙니다."
    exit 0
fi

echo
echo "  [/etc/passwd 파일 내용]"
echo "  (ㄱ) 시스템 사용자인데 로그인 가능한 쉘이 할당된 경우 점검"
echo "  (ㄴ) 일반 사용자 중 최근 1년간 로그인 기록이 없는 사용자 점검"
cat "$PASSWD_FILE"

echo
echo "  [lastlog 명령어 출력 내용]"
echo "  (ㄱ) 최근 1년간 로그인하지 않은 사용자 점검"
echo "  (ㄴ) 점검 후 고객과 상의 필요"
lastlog

echo
echo "  [su 명령어 실패 시도 기록 (/var/log/secure)]"
echo "  (ㄱ) su 인증 실패가 빈번한 사용자 점검 (일 20회 이상)"
echo "  (ㄴ) 일반 사용자가 root로 전환 시도하는 경우 집중 점검"
grep 'su: pam_unix(su-l:auth): authentication failure' /var/log/secure || echo "  관련 기록이 없습니다."

echo
echo "  점검 완료. 위 내용을 바탕으로 불필요한 계정 존재 여부를 확인하세요."
