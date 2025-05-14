#!/bin/bash
echo "U-26: 세션 타임아웃 설정 여부 점검"

# /etc/profile 파일에 TMOUT 설정 여부 확인
if grep -q "TMOUT=" /etc/profile; then
    echo "  [양호] 세션 타임아웃(TMOUT) 설정이 존재함"
else
    echo "  [취약] 세션 타임아웃(TMOUT) 설정이 존재하지 않음"
fi
