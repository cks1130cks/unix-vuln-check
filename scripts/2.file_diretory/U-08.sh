#!/bin/bash

echo "U-08: /etc/shadow 파일 소유자 및 권한 설정 점검"

TARGET_FILE="/etc/shadow"

if [ -f "$TARGET_FILE" ]; then
  FILE_OWNER=$(stat -c %U "$TARGET_FILE")
  FILE_PERM=$(stat -c %a "$TARGET_FILE")

  echo "  점검 대상 파일: $TARGET_FILE"
  echo "  현재 소유자: $FILE_OWNER"
  echo "  현재 권한: $FILE_PERM"

  if [ "$FILE_OWNER" = "root" ] && [ "$FILE_PERM" -eq 400 ]; then
    echo "  [양호] 파일 소유자가 root이고, 권한이 400 (소유자만 읽기) 으로 적절히 설정되어 있습니다."
  else
    echo "  [취약] 파일 소유자가 root가 아니거나 권한이 400이 아닙니다."
    echo "         권한과 소유자를 엄격하게 관리해야 패스워드 보안이 유지됩니다."
    echo "         현재 소유자: $FILE_OWNER, 현재 권한: $FILE_PERM"
    echo "         권장 권한: 400 (소유자만 읽기 권한), 소유자: root"
  fi
else
  echo "  [취약] $TARGET_FILE 파일이 존재하지 않습니다."
  echo "         시스템 보안에 심각한 영향을 줄 수 있으니 즉시 확인 바랍니다."
fi
