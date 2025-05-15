#!/bin/bash

echo "U-46: 패스워드 최소 길이 설정 점검"

LOGIN_DEFS="/etc/login.defs"
echo "  점검 파일: $LOGIN_DEFS"

# PASS_MIN_LEN 값 추출 (주석과 빈 줄 제외)
MIN_LEN=$(grep -E '^[[:space:]]*PASS_MIN_LEN[[:space:]]+' "$LOGIN_DEFS" | awk '{print $2}')

if [ -n "$MIN_LEN" ]; then
  echo "  설정된 PASS_MIN_LEN 값: $MIN_LEN"

  if [ "$MIN_LEN" -ge 8 ]; then
    echo "  [양호] 패스워드 최소 길이가 $MIN_LEN자로 설정되어 있습니다. (8자 이상)"
  else
    echo "  [취약] 패스워드 최소 길이가 $MIN_LEN자로 설정되어 있어 기준(8자) 미만입니다."
    echo "         보안을 위해 최소 8자 이상으로 설정해야 합니다."
  fi
else
  echo "  [취약] PASS_MIN_LEN 설정이 $LOGIN_DEFS 파일에 존재하지 않습니다."
  echo "         패스워드 최소 길이 설정이 누락되어 있어 보안에 취약할 수 있습니다."
fi
