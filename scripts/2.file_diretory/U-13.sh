#!/bin/bash

echo "U-13: SUID / SGID 설정 파일 점검"

# 허용된 표준 디렉터리 목록
ALLOWED_DIRS=("/usr/bin" "/usr/sbin" "/usr/lib" "/usr/libexec" "/usr/lib64")

# 모든 root 소유 SUID/SGID 파일 검색
SUID_SGID_FILES=$(find / -user root -type f \( -perm -4000 -o -perm -2000 \) -xdev 2>/dev/null)

FOUND=0
echo "  ➜ 총 발견된 SUID/SGID 파일 수: $(echo "$SUID_SGID_FILES" | wc -l)"

for FILE in $SUID_SGID_FILES; do
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
done

# 최종 평가
if [[ "$FOUND" -eq 0 ]]; then
  echo "  [양호] 모든 SUID/SGID 파일이 표준 디렉터리에만 존재합니다."
else
  echo "  [취약] 일부 SUID/SGID 파일이 비표준 위치에 존재합니다."
fi
