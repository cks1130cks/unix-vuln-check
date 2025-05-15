#!/bin/bash

echo "U-62: FTP 기본 계정에 쉘 설정 여부 점검"

# 1. FTP 계정 확인 (/etc/passwd에서 'ftp' 사용자 찾기)
ftp_users=$(grep -E '^ftp:' /etc/passwd)

if [ -z "$ftp_users" ]; then
    echo "  [양호] FTP 기본 계정이 존재하지 않습니다."
    exit 0
fi

# 2. FTP 계정의 쉘 확인
echo "  점검 대상 FTP 계정 정보:"
echo "$ftp_users" | while IFS=: read -r username _ _ _ _ _ shell; do
    echo "    - 사용자: $username, 쉘: $shell"
    if [[ "$shell" == "/bin/false" || "$shell" == "/sbin/nologin" ]]; then
        echo "      [양호] 안전한 쉘이 설정되어 있습니다."
    else
        echo "      [취약] 위험한 쉘이 설정되어 있습니다. /bin/false 또는 /sbin/nologin으로 변경 필요."
    fi
done
