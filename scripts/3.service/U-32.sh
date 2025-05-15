#!/bin/bash

echo "U-32: 일반 사용자 Sendmail 큐 실행 방지"
echo "  점검 파일: /etc/mail/sendmail.cf"

if grep -v '^ *#' /etc/mail/sendmail.cf | grep -q 'PrivacyOptions=.*restrictqrun'; then
    echo "  [양호] restrictqrun 설정이 존재함"
    echo "  설정 내용 예시:"
    grep -v '^ *#' /etc/mail/sendmail.cf | grep 'PrivacyOptions' | head -n 5 | sed 's/^/    /'
else
    echo "  [취약] restrictqrun 설정이 없음"
fi
