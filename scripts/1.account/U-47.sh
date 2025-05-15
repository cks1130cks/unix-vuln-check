#!/bin/bash

echo "U-47: 패스워드 최대 사용기간 설정 점검"

LOGIN_DEFS="/etc/login.defs"
echo "  점검 파일: $LOGIN_DEFS"

# PASS_MAX_DAYS 값 추출 (주석과 빈 줄 제외)
MAX_DAYS=$(grep -E '^[[:space:]]*PASS_MAX_DAYS[[:space:]]+' "$LOGIN_DEFS" | awk '{print $2}')

if [ -n "$MAX_DAYS" ]; then
  echo "  설정된 PASS_MAX_DAYS 값: $MAX_DAYS"

  if [ "$MAX_DAYS" -le 90 ]; then
    echo "  [양호] 패스워드 최대 사용기간이 $MAX_DAYS일로 설정되어 있습니다. (90일 이하)"
  else
    echo "  [취약] 패스워드 최대 사용기간이 $MAX_DAYS일로 설정되어 있어 기준(90일)을 초과합니다."
    echo "         장기간 동일한 패스워드 사용은 보안 위험을 증가시킬 수 있습니다."
  fi
else
  echo "  [취약] PASS_MAX_DAYS 설정이 $LOGIN_DEFS 파일에 존재하지 않습니다."
  echo "         패스워드 최대 사용기간을 설정하지 않으면 무기한 사용이 가능해 보안에 취약합니다."
fi
