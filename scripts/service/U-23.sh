#!/bin/bash
echo "U-23: 계정 잠금 임계값 설정 여부 점검"

# /etc/pam.d/system-auth 파일에 deny= 옵션이 있는지 확인
if grep -q "deny=" /etc/pam.d/system-auth; then
    echo "  [양호] 계정 잠금 임계값(deny) 옵션이 설정됨"
else
    echo "  [취약] 계정 잠금 임계값(deny) 옵션이 설정되지 않음"
fi
