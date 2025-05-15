#!/bin/bash

echo "U-12: /etc/services 파일 소유자 및 권한 설정 점검"

CHECK_FILE="/etc/services"

if [ -f "$CHECK_FILE" ]; then
  FILE_OWNER=$(stat -c %U "$CHECK_FILE")
  FILE_PERM=$(stat -c %a "$CHECK_FILE")

  echo "파일: $CHECK_FILE"
  echo "소유자: $FILE_OWNER"
  echo "권한: $FILE_PERM"

  if [ "$FILE_OWNER" = "root" ]; then
    if [ "$FILE_PERM" -le 644 ]; then
      echo "  [양호] 파일의 소유자가 root이고, 권한이 644 이하로 설정되어 있습니다. (현재 권한: $FILE_PERM)"
    else
      echo "  [취약] 파일 권한이 644 초과로 설정되어 있습니다. (현재 권한: $FILE_PERM)"
      echo "         권한을 644 이하로 낮추는 것이 보안상 적절합니다."
    fi
  else
    echo "  [취약] 파일 소유자가 root가 아닙니다. (현재 소유자: $FILE_OWNER)"
    echo "         파일 소유자를 root로 변경하는 것이 안전합니다."
  fi
else
  echo "  [취약] $CHECK_FILE 파일이 존재하지 않습니다."
  echo "         네트워크 서비스 관련 설정 파일이 없으므로 시스템 운영에 문제가 발생할 수 있습니다."
fi
