#!/bin/bash

echo "U-08: /etc/shadow 파일 소유자 및 권한 설정"

TARGET_FILE="/etc/shadow"

if [ -f "$TARGET_FILE" ]; then
  FILE_OWNER=$(stat -c %U "$TARGET_FILE")
  FILE_PERM=$(stat -c %a "$TARGET_FILE")

  if [ "$FILE_OWNER" = "root" ] && [ "$FILE_PERM" -eq 400 ]; then
    echo "  [양호] $TARGET_FILE 파일의 소유자가 root이고, 권한이 400입니다."
  else
    echo "  [취약] $TARGET_FILE 파일의 소유자가 root가 아니거나, 권한이 400이 아닙니다."
    echo "         현재 소유자: $FILE_OWNER, 권한: $FILE_PERM"
  fi
else
  echo "  [취약] $TARGET_FILE 파일이 존재하지 않습니다."
fi
