#!/bin/bash
echo "[U-21] r 계열 서비스 비활성화"
if [ -f /etc/xinetd.d/rlogin ] || [ -f /etc/xinetd.d/rsh ]; then
  echo "결과: 취약 (r 계열 서비스 관련 파일 존재)"
else
  echo "결과: 양호 (r 계열 서비스 관련 파일 없음)"
fi
