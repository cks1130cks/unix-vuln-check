#!/bin/bash
echo "[U-11] /etc/syslog.conf 파일 소유자 및 권한 점검"
FILE="/etc/syslog.conf"
if [ -f "$FILE" ]; then
  OWNER=$(stat -c %U "$FILE")
  PERM=$(stat -c %a "$FILE")
  if [ "$OWNER" = "root" ] && [ "$PERM" -le 644 ]; then
    echo "결과: 양호 ($FILE 소유자: $OWNER, 권한: $PERM)"
  else
    echo "결과: 취약 ($FILE 소유자: $OWNER, 권한: $PERM)"
  fi
else
  echo "결과: 양호 (관련 파일이 존재하지 않음)"
fi
