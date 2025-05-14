#!/bin/bash
echo "U-20: 패스워드 파일 권한 설정 점검"

# /etc/passwd 권한 확인 (644 이하인지)
if [ "$(stat -c %a /etc/passwd)" -le 644 ]; then
    echo "  [양호] /etc/passwd 파일 권한이 적절함"
else
    echo "  [취약] /etc/passwd 파일 권한이 과도함"
fi
