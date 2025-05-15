#!/bin/bash

echo "U-10: /etc/(x)inetd.conf 파일 소유자 및 권한 설정"

FILE="/etc/xinetd.conf"
PERM_EXPECTED="600"
OWNER_EXPECTED="root"

if [ -f "$FILE" ]; then
    FILE_OWNER=$(stat -c %U "$FILE")
    FILE_PERM=$(stat -c %a "$FILE")

    echo "파일: $FILE"
    echo "소유자: $FILE_OWNER"
    echo "권한: $FILE_PERM"

    if [ "$FILE_OWNER" = "$OWNER_EXPECTED" ]; then
        if [ "$FILE_PERM" = "$PERM_EXPECTED" ]; then
            echo "  [양호] 파일 소유자가 root이고 권한이 600입니다."
        else
            echo "  [취약] 파일 권한이 600이 아닙니다. (현재 권한: $FILE_PERM)"
        fi
    else
        echo "  [취약] 파일 소유자가 root가 아닙니다. (현재 소유자: $FILE_OWNER)"
    fi
else
    echo "  [취약] $FILE 파일이 존재하지 않습니다."
fi
