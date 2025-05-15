#!/bin/bash

# log_result 함수 대신 echo 사용
echo "U-01: root 원격접속 제한 점검"
grep -E "^PermitRootLogin[[:space:]]+no" /etc/ssh/sshd_config &>/dev/null && \
    echo "  [양호] SSH로 root 직접 로그인 금지 설정되어 있음." || \
    echo "  [취약] SSH로 root 직접 로그인 허용 중입니다. (/etc/ssh/sshd_config 확인 필요)"
