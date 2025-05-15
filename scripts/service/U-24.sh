#!/bin/bash
echo "[U-24] NFS 서비스 비활성화"
ps -ef | grep -E "nfs|statd|lockd" | grep -v grep > /tmp/u24_nfs_check.txt
if [ -s /tmp/u24_nfs_check.txt ]; then
  echo "결과: 취약 (NFS 관련 데몬 실행 중)"
  cat /tmp/u24_nfs_check.txt
else
  echo "결과: 양호 (NFS 관련 데몬 실행 안됨)"
fi
