#!/bin/bash

echo "U-07: /etc/passwd 파일 소유자 및 권한 설정"

CHECK_FILE="/etc/passwd"

if [ -f "$CHECK_FILE" ]; then
  FILE_OWNER=$(stat -c %U "$CHECK_FILE")
  FILE_PERM=$(stat -c %a "$CHECK_FILE")

  if [ "$FILE_OWNER" != "root" ]; then
    echo "  [취약] 파일의 소유자가 root가 아닙니다. (현재 소유자: $FILE_OWNER)"
  elif [ "$FILE_PERM" -gt 644 ]; then
    echo "  [취약] 파일 권한이 644 이상입니다. (현재 권한: $FILE_PERM)"
  else
    echo "  [양호] 파일 소유자가 root이고 권한이 644 이하입니다. (현재 권한: $FILE_PERM)"
  fi
else
  echo "  [정보] $CHECK_FILE 파일이 존재하지 않습니다."
fi
