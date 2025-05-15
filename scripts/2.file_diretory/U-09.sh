#!/bin/bash

echo "U-09: /etc/hosts 파일 소유자 및 권한 설정 점검"

CHECK_FILE="/etc/hosts"

if [ -f "$CHECK_FILE" ]; then
  FILE_OWNER=$(stat -c %U "$CHECK_FILE")
  FILE_PERM=$(stat -c %a "$CHECK_FILE")

  echo "  점검 대상 파일: $CHECK_FILE"
  echo "  현재 소유자: $FILE_OWNER"
  echo "  현재 권한: $FILE_PERM"

  if [ "$FILE_OWNER" = "root" ]; then
    if [ "$FILE_PERM" -le 600 ]; then
      echo "  [양호] 파일 소유자가 root이며, 권한이 600 이하로 적절히 설정되어 있습니다."
      echo "         (현재 권한: $FILE_PERM)"
    else
      echo "  [취약] 파일 권한이 600 초과로 설정되어 있습니다."
      echo "         권한이 너무 넓으면 시스템 호스트 정보가 노출될 수 있습니다."
      echo "         (현재 권한: $FILE_PERM)"
      echo "         권장 권한: 600 (소유자만 읽기/쓰기 권한)"
    fi
  else
    echo "  [취약] 파일 소유자가 root가 아닙니다."
    echo "         (현재 소유자: $FILE_OWNER)"
    echo "         보안을 위해 소유자를 root로 변경해야 합니다."
  fi
else
  echo "  [취약] $CHECK_FILE 파일이 존재하지 않습니다."
  echo "         시스템 정상 동작 및 보안을 위해 파일이 반드시 존재해야 합니다."
fi
