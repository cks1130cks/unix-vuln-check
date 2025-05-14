#!/bin/bash
echo "U-21: 패스워드 파일 암호화 저장 점검"

# /etc/shadow 권한 확인 (400 또는 000 인지)
perm=$(stat -c %a /etc/shadow 2>/dev/null)

if [ "$perm" = "000" ] || [ "$perm" = "400" ]; then
    echo "  [양호] /etc/shadow 파일 접근이 적절히 제한됨"
else
    echo "  [취약] /etc/shadow 파일 권한이 과도함 ($perm)"
fi
