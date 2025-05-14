#!/bin/bash
echo "U-24: 시스템 계정의 로그인 쉘 제한 점검"

# UID가 1000 미만이며 root가 아니고, 쉘이 /sbin/nologin 또는 /bin/false가 아닌 계정 찾기
invalid_shell_users=$(awk -F: '($3 < 1000 && $1 != "root" && $7 != "/sbin/nologin" && $7 != "/bin/false") {print $1}' /etc/passwd)

if [ -z "$invalid_shell_users" ]; then
    echo "  [양호] 시스템 계정에 로그인 쉘이 적절히 제한됨"
else
    echo "  [취약] 로그인 쉘이 제한되지 않은 시스템 계정 존재: $invalid_shell_users"
fi
