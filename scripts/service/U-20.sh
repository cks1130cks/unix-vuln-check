#!/bin/bash
echo "[U-20] Anonymous FTP 비활성화"
if grep -i "anonymous" /etc/vsftpd/ftpusers 2>/dev/null | grep -qv '^#'; then
  echo "결과: 양호 (anonymous 계정이 차단됨)"
else
  echo "결과: 취약 (anonymous 계정 차단 설정이 없음 또는 주석 처리됨)"
fi
