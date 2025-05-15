#!/bin/bash
echo "U-03: 계정 잠금 임계값 설정 점검"

PAM_SYSTEM_AUTH="/etc/pam.d/system-auth"

FindDenyValue() {
  egrep -v '^#|^$' "$1" | grep 'pam_tally2.so' | grep -o 'deny=[0-9]*' | cut -d= -f2 | head -n1
}

DENY_VALUE=$(FindDenyValue "$PAM_SYSTEM_AUTH")

if [ -n "$DENY_VALUE" ]; then
  if [ "$DENY_VALUE" -le 5 ]; then
    echo "  [양호] (계정 잠금 임계값이 $DENY_VALUE로 설정됨)"
  else
    echo "  [취약] (계정 잠금 임계값이 $DENY_VALUE로 설정됨 — 5 초과)"
  fi
else
  echo "  [취약] (계정 잠금 임계값이 설정되어 있지 않음)"
fi
