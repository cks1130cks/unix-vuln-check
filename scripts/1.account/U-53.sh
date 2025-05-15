#!/bin/bash

echo "U-53: 시스템 계정에 로그인 shell 부여 금지 점검"

PASSWD_FILE="/etc/passwd"
echo "  점검 파일: $PASSWD_FILE"

# UID 1000 미만(시스템 계정)인데 로그인 가능한 쉘을 가진 계정 추출
issues=$(awk -F: '$3 < 1000 && $7 !~ /(nologin|false|\/sbin\/halt|\/sbin\/sync|\/sbin\/shutdown)/ {print $1, $7}' "$PASSWD_FILE")

if [ -n "$issues" ]; then
    echo "  [취약] 로그인 가능한 시스템 계정이 존재합니다:"
    echo "         시스템 계정은 로그인 쉘이 없는 것이 보안 권장사항입니다."
    echo "         문제 계정과 쉘:"
    echo "$issues" | sed 's/^/           - /'
    echo "         필요시 로그인 쉘을 /sbin/nologin 또는 /bin/false 등으로 변경하십시오."
else
    echo "  [양호] 시스템 계정에 로그인 쉘이 부여되어 있지 않습니다."
fi
