#!/bin/bash

echo "U-14: 환경 변수 파일 권한 점검"

FILES=(
  "/root/.profile"
  "/root/.kshrc"
  "/root/.cshrc"
  "/root/.bashrc"
  "/root/.bash_profile"
  "/root/.login"
  "/root/.exrc"
  "/root/.netrc"
)

for FILE in "${FILES[@]}"; do
  if [ -f "$FILE" ]; then
    OWNER=$(stat -c %U "$FILE")
    PERM=$(stat -c %a "$FILE")

    echo "  점검 대상 파일: $FILE"
    echo "  현재 소유자: $OWNER"
    echo "  현재 권한: $PERM"

    if [ "$OWNER" != "root" ] || [ "$PERM" -gt 644 ]; then
      echo "  [취약] 파일 소유자가 root가 아니거나 권한이 644 초과입니다."
      echo "         소유자를 root로 변경하고 권한을 644 이하로 설정하는 것이 안전합니다."
    else
      echo "  [양호] 파일 소유자와 권한이 적절히 설정되어 있습니다."
    fi
    echo ""
  fi
done
