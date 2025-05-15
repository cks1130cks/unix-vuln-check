#!/bin/bash
echo "[U-14] 환경 변수 파일 권한 점검"
FILES=("/root/.profile" "/root/.kshrc" "/root/.cshrc" "/root/.bashrc" "/root/.bash_profile" "/root/.login" "/root/.exrc" "/root/.netrc")
for FILE in "${FILES[@]}"; do
  if [ -f "$FILE" ]; then
    OWNER=$(stat -c %U "$FILE")
    PERM=$(stat -c %a "$FILE")
    if [ "$OWNER" != "root" ] || [ "$PERM" -gt 644 ]; then
      echo "결과: 취약 ($FILE 소유자=$OWNER, 권한=$PERM)"
    else
      echo "결과: 양호 ($FILE 소유자=$OWNER, 권한=$PERM)"
    fi
  fi
done
