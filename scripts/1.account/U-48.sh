#!/bin/bash

echo "U-48: 패스워드 최소 사용기간 설정 점검"

LOGIN_DEFS="/etc/login.defs"
echo "  점검 파일: $LOGIN_DEFS"

# PASS_MIN_DAYS 값 추출 (주석 제외, 공백 제거)
MIN_DAYS=$(grep -E '^[[:space:]]*PASS_MIN_DAYS[[:space:]]+' "$LOGIN_DEFS" | awk '{print $2}')

if [ -n "$MIN_DAYS" ]; then
  echo "  설정된 PASS_MIN_DAYS 값: $MIN_DAYS"

  if [ "$MIN_DAYS" -ge 1 ]; then
    echo "  [양호] 패스워드 최소 사용기간이 $MIN_DAYS일로 설정되어 있습니다. (1일 이상)"
  else
    echo "  [취약] 패스워드 최소 사용기간이 $MIN_DAYS일로 설정되어 있어 기준(1일 이상)에 미달합니다."
    echo "         사용자 패스워드 변경 후 바로 재변경이 가능하여 보안상 우회 가능성이 있습니다."
  fi
else
  echo "  [취약] PASS_MIN_DAYS 설정이 $LOGIN_DEFS 파일에 존재하지 않습니다."
  echo "         최소 사용기간을 설정하지 않으면 패스워드 변경 제한이 없어 보안 우회에 취약할 수 있습니다."
fi
