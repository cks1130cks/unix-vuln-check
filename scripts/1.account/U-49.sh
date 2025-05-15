#!/bin/bash

echo "U-49: 불필요한 계정 제거 점검"

PASSWD_FILE="/etc/passwd"
SECURE_LOG="/var/log/secure"

if [ ! -f "$PASSWD_FILE" ]; then
    echo "  [정보] /etc/passwd 파일이 없습니다. 점검 대상 아님."
    exit 0
fi

echo
echo "  [1] 로그인 가능한 시스템 사용자 점검"
login_users=$(awk -F: '($7 !~ /(nologin|false|sync)$/) {print $1}' $PASSWD_FILE)
if [ -z "$login_users" ]; then
    echo "    [양호] 로그인 가능한 시스템 사용자가 없습니다."
else
    echo "    로그인 가능한 사용자 목록:"
    echo "$login_users" | sed 's/^/      /'
    echo "    [취약] 로그인 가능한 시스템 사용자가 존재합니다."
fi

echo
echo "  [2] 최근 1년간 로그인 기록 없는 사용자 점검"
no_login_users=$(lastlog -b 365 | awk 'NR>1 && ($4=="**Never logged in**") {print $1}')
if [ -z "$no_login_users" ]; then
    echo "    [양호] 최근 1년간 로그인하지 않은 사용자가 없습니다."
else
    echo "    최근 1년간 로그인하지 않은 사용자:"
    echo "$no_login_users" | sed 's/^/      /'
    echo "    [취약] 로그인하지 않은 사용자가 존재합니다. 제거 또는 확인 필요."
fi

echo
echo "  [3] su 인증 실패 다빈도 사용자 점검 (일 20회 이상)"
if [ ! -f "$SECURE_LOG" ]; then
    echo "    [정보] $SECURE_LOG 파일이 없어 점검할 수 없습니다."
else
    fail_users=$(grep 'su: pam_unix(su-l:auth): authentication failure' $SECURE_LOG 2>/dev/null | \
        awk '{print $1,$2,$3,$11}' | sort | uniq -c | awk '$1 >= 20 {print $2}')
    if [ -z "$fail_users" ]; then
        echo "    [양호] 하루 20회 이상 su 인증 실패 사용자가 없습니다."
    else
        echo "    하루 20회 이상 su 인증 실패 사용자:"
        echo "$fail_users" | sed 's/^/      /'
        echo "    [취약] su 인증 실패가 빈번한 사용자가 존재합니다."
    fi
fi

echo
echo "  점검 완료. 필요 시 불필요한 계정에 대해 조치하세요."
