#!/bin/bash
echo "U-31: 릴레이 제한 설정 확인"
if grep -q 'R\$\*\s\+\$#error\s\+\$@\s\+5.7.1\s\+\$:.*Relaying denied' /etc/mail/sendmail.cf 2>/dev/null; then
    echo "  [양호] (릴레이 제한 설정 존재)"
else
    echo "  [취약] (릴레이 제한 설정 없음)"
fi
