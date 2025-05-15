#!/bin/bash

echo "U-12: /etc/services 파일 소유자 및 권한 설정"

CHECK_FILE="/etc/services"

if [ -f "$CHECK_FILE" ]; then
  FILE_OWNER=$(stat -c %U "$CHECK_FILE")
  FILE_PERM=$(stat -c %a "$CHECK_FILE")

  echo "파일: $CHECK_FILE"
  echo "소유자: $FILE_OWNER"
  echo "권한: $FILE_PERM"

  if [ "$FILE_OWNER" = "root" ]; then
    if [ "$FILE_PERM" -le 644 ]; then
      echo "  [양호] 파일의 소유자가 root이고, 권한이 644 이하입니다. (현재 권한: $FILE_PERM)"
    else
      echo "  [취약] 파일의 권한이 644 초과입니다. (현재 권한: $FILE_PERM)"
    fi
  else
    echo "  [취약] 파일의 소유자가 root가 아닙니다. (현재 소유자: $FILE_OWNER)"
  fi
else
  echo "  [취약] $CHECK_FILE 파일이 존재하지 않습니다."
fi
