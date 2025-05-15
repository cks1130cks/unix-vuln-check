#!/bin/bash

echo "U-22: cron 관련 파일 및 실행파일 소유자 및 권한 설정 점검"

FILES=("/etc/crontab" "/etc/cron.allow" "/etc/cron.deny")

echo "  점검 대상 파일:"
for file in "${FILES[@]}"; do
  echo "    - $file"
done
echo "    - /usr/bin/crontab (실행파일 권한)"

echo

# 설정 파일 권한 점검
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


# crontab 실행파일 권한 점검
CRONTAB_BIN="/usr/bin/crontab"
if [ -f "$CRONTAB_BIN" ]; then
  PERM=$(stat -c %a "$CRONTAB_BIN")
  OWNER=$(stat -c %U "$CRONTAB_BIN")
  # 일반 사용자가 사용 불가능 하려면 권한이 700 이하 (rwx------) 이거나 750 등으로 제한되어야 함
  # setuid bit 포함시 권한 숫자 커질 수 있음. 일반적으로 700 이하로 제한 권장
  if [ "$OWNER" = "root" ] && [ "$PERM" -le 700 ]; then
    echo "  [양호] $CRONTAB_BIN 실행파일 (소유자: $OWNER, 권한: $PERM)"
  else
    echo "  [취약] $CRONTAB_BIN 실행파일 (소유자: $OWNER, 권한: $PERM)"
  fi
else
  echo "  [정보] $CRONTAB_BIN 파일이 존재하지 않습니다."
fi
