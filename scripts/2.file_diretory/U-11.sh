#!/bin/bash

echo "U-11: /etc/rsyslog.conf 파일 소유자 및 권한 설정"

FILE=/etc/rsyslog.conf
PERM_EXPECTED=644
OWNER_EXPECTED="root"

if [ ! -f "$FILE" ]; then
  echo "  [취약] $FILE 파일이 존재하지 않습니다."
  exit 1
fi

FILE_OWNER=$(stat -c %U "$FILE")
FILE_PERM=$(stat -c %a "$FILE")

if [ "$FILE_OWNER" != "$OWNER_EXPECTED" ]; then
  echo "  [취약] 파일 소유자가 $OWNER_EXPECTED 가 아닙니다. 현재: $FILE_OWNER"
elif [ "$FILE_PERM" != "$PERM_EXPECTED" ]; then
  echo "  [취약] 파일 권한이 $PERM_EXPECTED 가 아닙니다. 현재: $FILE_PERM"
else
  echo "  [양호] 파일 소유자와 권한이 적절히 설정되어 있습니다. (소유자: $FILE_OWNER, 권한: $FILE_PERM)"
fi
