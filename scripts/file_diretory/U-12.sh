#!/bin/bash
echo "[U-12] /etc/services 파일 소유자 및 권한 점검"
FILE="/etc/services"
if [ -f "$FILE" ]; then
  OWNER=$(stat -c %U "$FILE")
  PERM=$(stat -c %a "$FILE")
  if [[ "$OWNER" =~ ^(root|bin|sys)$ ]] && [ "$PERM" -le 644 ]; then
    echo "결과: 양호 ($FILE 소유자: $OWNER, 권한: $PERM)"
  else
    echo "결과: 취약 ($FILE 소유자: $OWNER, 권한: $PERM)"
  fi
else
  echo "결과: 취약 ($FILE 파일 없음)"
fi
