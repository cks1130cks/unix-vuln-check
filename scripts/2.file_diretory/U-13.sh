#!/bin/bash

echo "U-13: SUID / SGID 설정 파일 점검"

# 허용된 표준 디렉터리 목록
ALLOWED_DIRS=("/usr/bin" "/usr/sbin" "/usr/lib" "/usr/libexec" "/usr/lib64")

# 모든 root 소유 SUID/SGID 파일 검색 (루트 파일 시스템만)
SUID_SGID_FILES=$(find / -xdev -user root -type f \( -perm -4000 -o -perm -2000 \) 2>/dev/null)

FILE_COUNT=$(echo "$SUID_SGID_FILES" | grep -c '^')
echo "  ➜ 총 발견된 SUID/SGID 파일 수: $FILE_COUNT"

FOUND=0
while IFS= read -r FILE; do
  VALID=0
  for DIR in "${ALLOWED_DIRS[@]}"; do
    if [[ "$FILE" == $DIR/* ]]; then
      VALID=1
      break
    fi
  done

  if [[ "$VALID" -eq 0 ]]; then
    echo "  [취약] 비표준 위치의 SUID/SGID 파일 발견: $FILE"
    FOUND=1
  fi
done <<< "$SUID_SGID_FILES"

if [[ "$FOUND" -eq 0 ]]; then
  echo "  [양호] 모든 SUID/SGID 파일이 표준 디렉터리에만 존재합니다."
else
  echo "  [취약] 일부 SUID/SGID 파일이 비표준 위치에 존재합니다."
fi
