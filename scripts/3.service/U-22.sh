#!/bin/bash

echo "U-22: cron 관련 파일 소유자 및 권한 설정 점검"

FILES=("/etc/crontab" "/etc/cron.allow" "/etc/cron.deny")

echo "  점검 대상 파일:"
for file in "${FILES[@]}"; do
  echo "    - $file"
done

for file in "${FILES[@]}"; do
  if [ -e "$file" ]; then
    PERM=$(stat -c %a "$file")
    OWNER=$(stat -c %U "$file")
    if [ "$OWNER" = "root" ] && [ "$PERM" -le 644 ]; then
      echo "  [양호] $file (소유자: $OWNER, 권한: $PERM)"
    else
      echo "  [취약] $file (소유자: $OWNER, 권한: $PERM)"
    fi
  else
    echo "  [정보] $file 파일이 존재하지 않습니다."
  fi
done
