#!/bin/bash

echo "U-31: 릴레이 제한 설정 확인"
echo "  점검 파일: /etc/mail/sendmail.cf"

if grep -q 'R\$\*\s\+\$#error\s\+\$@\s\+5.7.1\s\+\$:.*Relaying denied' /etc/mail/sendmail.cf 2>/dev/null; then
    echo "  [양호] 릴레이 제한 설정이 존재함"
    echo "  설정 내용 예시:"
    grep 'R$*' /etc/mail/sendmail.cf | grep 'Relaying denied' | head -n 5 | sed 's/^/    /'
else
    echo "  [취약] 릴레이 제한 설정이 없음"
fi
