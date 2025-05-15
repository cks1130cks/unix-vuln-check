#!/bin/bash

echo "U-32: 일반 사용자 Sendmail 큐 실행 방지"
echo "  점검 파일: /etc/mail/sendmail.cf"

if grep -v '^ *#' /etc/mail/sendmail.cf | grep -q 'PrivacyOptions=.*restrictqrun'; then
    echo "  [양호] restrictqrun 설정이 있어 일반 사용자 큐 실행이 제한됩니다."
else
    echo "  [취약] restrictqrun 설정이 없어 일반 사용자 큐 실행이 가능합니다."
    echo "    → sendmail.cf에 'PrivacyOptions=restrictqrun' 추가 필요"
fi
