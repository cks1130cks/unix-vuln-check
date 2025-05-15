#!/bin/bash

echo "U-70: expn, vrfy 명령어 제한"

# SMTP 서비스가 활성화 되어 있는지 확인
if systemctl is-active --quiet postfix; then
    echo "  [INFO] SMTP 서비스(postfix)가 활성화 되어 있습니다."

    # postfix 설정 파일에서 noexpn, novrfy 옵션이 설정되어 있는지 점검
    if grep -q "disable_vrfy_command = yes" /etc/postfix/main.cf && grep -q "disable_expn_command = yes" /etc/postfix/main.cf; then
        echo "  [양호] SMTP 서비스에서 vrfy, expn 명령어가 비활성화 되어 있습니다."
    else
        echo "  [취약] SMTP 서비스에서 vrfy, expn 명령어가 비활성화 되어 있지 않습니다."
    fi
else
    echo "  [양호] SMTP 서비스가 사용되지 않거나 비활성화 되어 있습니다."
fi
