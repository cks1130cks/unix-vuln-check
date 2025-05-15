#!/bin/bash
echo "U-25: NFS 접근 통제 설정 점검"

FILE="/etc/exports"

if [ -f "$FILE" ]; then
  if grep -Eqv 'root|rw|ro|no_root_squash' "$FILE"; then
    echo "  [취약] 적절한 접근 통제 설정 없음"
  else
    echo "  [양호] $FILE에 적절한 접근 통제 설정"
  fi
else
  echo "  [양호] $FILE 파일 없음"
fi
