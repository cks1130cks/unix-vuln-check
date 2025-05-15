#!/bin/bash

echo "U-31: 릴레이 제한 설정 확인"
echo "  점검 파일: /etc/mail/sendmail.cf"

if grep -q 'R\$\*\s\+\$#error\s\+\$@\s\+5.7.1\s\+\$:.*Relaying denied' /etc/mail/sendmail.cf 2>/dev/null; then
    echo "  [양호] 릴레이 제한 설정이 존재합니다."
    echo "    - 외부 메일 릴레이가 차단되어 있어 메일 서버가 스팸 발송 등의 악용으로부터 보호되고 있습니다."
    echo "    - 설정 내용은 sendmail.cf 파일 내에 'Relaying denied' 메시지를 포함하는 에러 처리가 구현되어 있습니다."
else
    echo "  [취약] 릴레이 제한 설정이 존재하지 않습니다."
    echo "    - 외부에서 메일 릴레이가 허용될 경우, 스팸 메일 발송 및 서버 악용 위험이 있습니다."
    echo "    - sendmail.cf 파일에 릴레이 제한 규칙을 추가하여 불필요한 릴레이를 차단해야 합니다."
    echo "    - 예를 들어, 다음과 같은 설정이 필요합니다:"
    echo "      R\$*    $#error    \$@    5.7.1    \$: 'Relaying denied'"
fi
