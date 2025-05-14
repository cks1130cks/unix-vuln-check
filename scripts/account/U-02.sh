log_result "U-02: 패스워드 복잡성 설정 점검"
CONF="/etc/security/pwquality.conf"
if [ -f "$CONF" ]; then
    grep -q "minlen=8" "$CONF" && \
    grep -q "ucredit=-1" "$CONF" && \
    grep -q "lcredit=-1" "$CONF" && \
    grep -q "dcredit=-1" "$CONF" && \
    grep -q "ocredit=-1" "$CONF" && \
        log_result "  [양호] 패스워드 복잡성 정책이 설정되어 있음." || \
        log_result "  [취약] 패스워드 복잡성 설정 미흡. ($CONF 확인 필요)"
else
    log_result "  [확인불가] $CONF 파일 없음"
fi
