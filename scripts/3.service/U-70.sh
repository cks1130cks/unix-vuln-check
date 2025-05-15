#!/bin/bash

echo "U-70: expn, vrfy 명령어 제한"

# SMTP 서비스가 활성화 되어 있는지 확인
if systemctl is-active --quiet postfix; then
    echo "  [INFO] SMTP 서비스(postfix)가 활성화 되어 있습니다."

    # postfix 설정 파일에서 disable_vrfy_command 및 disable_expn_command 옵션 점검
    conf_file="/etc/postfix/main.cf"

    if [ -f "$conf_file" ]; then
        disable_vrfy=$(grep -E "^disable_vrfy_command\s*=\s*yes" "$conf_file")
        disable_expn=$(grep -E "^disable_expn_command\s*=\s*yes" "$conf_file")

        if [ -n "$disable_vrfy" ] && [ -n "$disable_expn" ]; then
            echo "  [양호] SMTP 서비스에서 vrfy, expn 명령어가 비활성화 되어 있습니다."
        else
            echo "  [취약] SMTP 서비스에서 vrfy, expn 명령어가 비활성화 되어 있지 않습니다."
        fi
    else
        echo "  [취약] Postfix 설정 파일($conf_file)이 존재하지 않습니다."
    fi
else
    echo "  [양호] SMTP 서비스가 사용되지 않거나 비활성화 되어 있습니다."
fi
