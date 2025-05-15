#!/bin/bash
echo "U-25: NFS 접근 통제 설정 점검"

FILE="/etc/exports"

echo "  점검 대상 파일: $FILE"

if [ -f "$FILE" ]; then
  # 접근 통제 관련 설정이 존재하는지 확인 (root, rw, ro, no_root_squash 중 하나라도 있으면 양호 판단)
  if grep -Eq 'root|rw|ro|no_root_squash' "$FILE"; then
    echo "  [양호] $FILE에 적절한 접근 통제 설정이 존재합니다."
  else
    echo "  [취약] $FILE에 적절한 접근 통제 설정이 없습니다."
  fi
else
  echo "  [양호] $FILE 파일이 존재하지 않습니다."
fi
