#!/bin/bash
echo "[U-28] NIS, NIS+ 서비스 점검"
ps -ef | grep -E "ypbind|rpc.yppasswdd|ypserv|ypset" | grep -v grep > /tmp/u28_nis.txt
if [ -s /tmp/u28_nis.txt ]; then
  echo "결과: 취약 (NIS 관련 데몬 실행 중)"
  cat /tmp/u28_nis.txt
else
  echo "결과: 양호 (NIS 관련 데몬 실행 안됨)"
fi
