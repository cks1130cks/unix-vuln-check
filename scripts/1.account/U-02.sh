#!/bin/bash

# U-02: 패스워드 복잡성 설정 점검
echo "U-02: 패스워드 복잡성 설정 점검"

# 패스워드 복잡성 정책 파일 경로
CONF="/etc/security/pwquality.conf"

# 설정 파일이 존재하는지 확인
if [ -f "$CONF" ]; then
    # 패스워드 복잡성 설정 확인
    grep -q "minlen=8" "$CONF" && \
    grep -q "ucredit=-1" "$CONF" && \
    grep -q "lcredit=-1" "$CONF" && \
    grep -q "dcredit=-1" "$CONF" && \
    grep -q "ocredit=-1" "$CONF" && \
        echo "  [양호] 패스워드 복잡성 정책이 설정되어 있음." || \
        echo "  [취약] 패스워드 복잡성 설정 미흡. ($CONF 확인 필요)"
else
    echo "  [확인불가] $CONF 파일 없음"
fi
