#!/bin/bash

echo "U-09: /etc/hosts 파일 소유자 및 권한 설정"

CHECK_FILE="/etc/hosts"

if [ -f "$CHECK_FILE" ]; then
  FILE_OWNER=$(stat -c %U "$CHECK_FILE")
  FILE_PERM=$(stat -c %a "$CHECK_FILE")

  if [ "$FILE_OWNER" = "root" ]; then
    if [ "$FILE_PERM" -le 600 ]; then
      echo "  [양호] 파일의 소유자가 root이며 권한이 600 이하로 설정되어 있습니다. (현재 권한: $FILE_PERM)"
    else
      echo "  [취약] 파일 권한이 600 초과로 설정되어 있습니다. (현재 권한: $FILE_PERM)"
    fi
  else
    echo "  [취약] 파일의 소유자가 root가 아닙니다. (현재 소유자: $FILE_OWNER)"
  fi
else
  echo "  [취약] $CHECK_FILE 파일이 존재하지 않습니다."
fi
