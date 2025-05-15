#!/bin/bash
echo "U-03: 계정 잠금 임계값 설정 점검"

PAM_SYSTEM_AUTH="/etc/pam.d/system-auth"
echo "  점검 파일: $PAM_SYSTEM_AUTH"

FindDenyValue() {
  # 주석 및 빈 줄 제거 후 pam_tally2.so 또는 pam_faillock.so 관련 deny 옵션 추출
  egrep -v '^#|^$' "$1" | grep -E 'pam_tally2.so|pam_faillock.so' | grep -o 'deny=[0-9]*' | cut -d= -f2 | head -n1
}

DENY_VALUE=$(FindDenyValue "$PAM_SYSTEM_AUTH")

if [ -n "$DENY_VALUE" ]; then
  if [ "$DENY_VALUE" -le 5 ]; then
    echo "  [양호] 계정 잠금 임계값이 보안 기준 이내로 설정되어 있습니다."
    echo "         설정된 deny 값: $DENY_VALUE (기준: 5 이하 권장)"
  else
    echo "  [취약] 계정 잠금 임계값이 기준보다 높게 설정되어 있습니다."
    echo "         설정된 deny 값: $DENY_VALUE (기준: 5 이하 권장)"
  fi
else
  echo "  [취약] 계정 잠금 임계값(deny)이 설정되어 있지 않습니다."
  echo "         pam_tally2.so 또는 pam_faillock.so 모듈 내 deny 옵션을 설정해야 합니다."
fi
