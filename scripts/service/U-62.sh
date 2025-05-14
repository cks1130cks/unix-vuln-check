#!/bin/bash

echo "U-62: FTP 기본 계정에 쉘 설정 여부 점검"

# 1. FTP 계정 확인
ftp_users=$(grep -E '^ftp' /etc/passwd)

if [ -z "$ftp_users" ]; then
    echo "  [양호] FTP 기본 계정이 없습니다."
    exit 0
fi

# 2. FTP 계정의 쉘 확인
for user in $ftp_users; do
    shell=$(echo $user | cut -d: -f7)
    
    if [ "$shell" == "/bin/false" ]; then
        echo "  [양호] FTP 계정에 /bin/false 쉘이 부여되어 있습니다."
    else
        echo "  [취약] FTP 계정에 /bin/false 쉘이 부여되어 있지 않습니다. /bin/false 쉘을 설정해야 합니다."
    fi
done
