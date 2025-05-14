log_result "U-01: root 원격접속 제한 점검"
grep -E "^PermitRootLogin[[:space:]]+no" /etc/ssh/sshd_config &>/dev/null && \
    log_result "  [양호] SSH로 root 직접 로그인 금지 설정되어 있음." || \
    log_result "  [취약] SSH로 root 직접 로그인 허용 중입니다. (/etc/ssh/sshd_config 확인 필요)"