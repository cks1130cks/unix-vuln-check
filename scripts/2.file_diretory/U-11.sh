#!/bin/bash

echo "U-11: /etc/rsyslog.conf 파일 소유자 및 권한 설정 점검"

FILE=/etc/rsyslog.conf
PERM_EXPECTED=640
OWNER_EXPECTED="root"

if [ ! -f "$FILE" ]; then
  echo "  [취약] $FILE 파일이 존재하지 않습니다."
  echo "         시스템 로그 관리에 영향을 줄 수 있으니 파일 존재 여부를 확인하세요."
  exit 1
fi

FILE_OWNER=$(stat -c %U "$FILE")
FILE_PERM=$(stat -c %a "$FILE")

echo "  점검 대상 파일: $FILE"
echo "  현재 소유자: $FILE_OWNER"
echo "  현재 권한: $FILE_PERM"

if [ "$FILE_OWNER" != "$OWNER_EXPECTED" ]; then
  echo "  [취약] 파일 소유자가 $OWNER_EXPECTED 가 아닙니다."
  echo "         보안을 위해 소유자를 root로 변경할 것을 권장합니다."
elif [ "$FILE_PERM" != "$PERM_EXPECTED" ]; then
  echo "  [취약] 파일 권한이 $PERM_EXPECTED 가 아닙니다."
  echo "         권한을 640로 설정하는 것이 보안상 적절합니다."
else
  echo "  [양호] 파일 소유자와 권한이 적절히 설정되어 있습니다."
fi
