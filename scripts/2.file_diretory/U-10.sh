#!/bin/bash

echo "U-10: /etc/(x)inetd.conf 파일 소유자 및 권한 설정 점검"

FILE="/etc/xinetd.conf"
PERM_EXPECTED="600"
OWNER_EXPECTED="root"

if [ -f "$FILE" ]; then
    FILE_OWNER=$(stat -c %U "$FILE")
    FILE_PERM=$(stat -c %a "$FILE")

    echo "  점검 대상 파일: $FILE"
    echo "  현재 소유자: $FILE_OWNER"
    echo "  현재 권한: $FILE_PERM"

    if [ "$FILE_OWNER" = "$OWNER_EXPECTED" ]; then
        if [ "$FILE_PERM" = "$PERM_EXPECTED" ]; then
            echo "  [양호] 파일 소유자가 root이고 권한이 600으로 적절히 설정되어 있습니다."
        else
            echo "  [취약] 파일 권한이 권장값 600이 아닙니다."
            echo "         (현재 권한: $FILE_PERM)"
            echo "         보안을 위해 권한을 600으로 설정할 것을 권장합니다."
        fi
    else
        echo "  [취약] 파일 소유자가 root가 아닙니다."
        echo "         (현재 소유자: $FILE_OWNER)"
        echo "         보안을 위해 소유자를 root로 변경할 것을 권장합니다."
    fi
else
    echo "  [취약] $FILE 파일이 존재하지 않습니다."
    echo "         서비스 설정 및 보안을 위해 해당 파일이 존재해야 합니다."
fi
