#!/bin/bash

echo "U-07: /etc/passwd 파일 소유자 및 권한 설정 점검"

CHECK_FILE="/etc/passwd"

if [ -f "$CHECK_FILE" ]; then
  FILE_OWNER=$(stat -c %U "$CHECK_FILE")
  FILE_PERM=$(stat -c %a "$CHECK_FILE")

  echo "  점검 대상 파일: $CHECK_FILE"
  echo "  현재 소유자: $FILE_OWNER"
  echo "  현재 권한: $FILE_PERM"

  if [ "$FILE_OWNER" != "root" ]; then
    echo "  [취약] 파일 소유자가 root가 아닙니다."
    echo "         보안을 위해 소유자를 root로 설정해야 합니다."
  elif [ "$FILE_PERM" -gt 644 ]; then
    echo "  [취약] 파일 권한이 644(소유자 rw-, 그룹 r--, 기타 r--) 보다 넓게 설정되어 있습니다."
    echo "         현재 권한: $FILE_PERM"
    echo "         권한을 644 이하로 제한하는 것을 권장합니다."
  else
    echo "  [양호] 파일 소유자가 root이며 권한이 644 이하로 적절히 설정되어 있습니다."
  fi
else
  echo "  [정보] $CHECK_FILE 파일이 존재하지 않습니다."
  echo "         파일이 없으면 시스템 동작에 문제가 있을 수 있으니 확인이 필요합니다."
fi
