#!/bin/bash

echo "U-31: 릴레이 제한 설정 확인"
echo "  점검 파일: /etc/mail/sendmail.cf"

if grep -q 'R\$\*\s\+\$#error\s\+\$@\s\+5.7.1\s\+\$:.*Relaying denied' /etc/mail/sendmail.cf 2>/dev/null; then
    echo "  [양호] 릴레이 제한 설정이 존재합니다."
    echo "    - 외부 메일 릴레이가 차단되어 스팸 발송 및 서버 악용 위험이 줄어듭니다."
else
    echo "  [취약] 릴레이 제한 설정이 존재하지 않습니다."
    echo "    - 외부 릴레이 허용 시 스팸 및 서버 악용 위험이 있습니다."
    echo "    - sendmail.cf에 다음 설정을 추가해야 합니다:"
    echo "      R\$*    $#error    \$@    5.7.1    \$: 'Relaying denied'"
fi
