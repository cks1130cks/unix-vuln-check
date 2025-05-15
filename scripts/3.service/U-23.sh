#!/bin/bash
echo "[U-23] Dos 공격에 취약한 서비스 비활성화"
if [ -f /etc/xinetd.d/echo ] || [ -f /etc/xinetd.d/discard ] || [ -f /etc/xinetd.d/daytime ]; then
  echo "결과: 취약 (취약한 echo/discard/daytime 서비스 파일 존재)"
else
  echo "결과: 양호 (취약 서비스 비활성화 상태)"
fi
