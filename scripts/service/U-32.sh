#!/bin/bash
echo "[U-32] 일반 사용자 Sendmail 큐 실행 방지"
if grep -v '^ *#' /etc/mail/sendmail.cf | grep -q 'PrivacyOptions=.*restrictqrun'; then
    echo "결과: 양호 (restrictqrun 설정 있음)"
else
    echo "결과: 취약 (restrictqrun 설정 없음)"
fi
