#!/bin/bash

# U-03: 계정 잠금 임계값 설정 점검
echo "U-03: 계정 잠금 임계값 설정 점검"

# pam_tally2 설정 확인
grep -q "pam_tally2" /etc/pam.d/system-auth && \
    echo "  [양호] pam_tally2를 통한 계정 잠금 정책 설정 확인됨." || \
    echo "  [취약] pam_tally2 계정 잠금 정책 미설정."
