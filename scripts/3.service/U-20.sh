#!/bin/bash

echo "U-20: Anonymous FTP 비활성화 점검"

FILE="/etc/vsftpd/ftpusers"

echo "  점검 파일: $FILE"

if grep -i "anonymous" "$FILE" 2>/dev/null | grep -qv '^#'; then
  echo "  [양호] anonymous 계정이 차단됨"
else
  echo "  [취약] anonymous 계정 차단 설정이 없거나 주석 처리됨"
fi
