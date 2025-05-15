#!/bin/bash
echo "U-24: NFS 서비스 비활성화 점검"

echo "  점검 내용: nfs, statd, lockd 데몬 실행 여부 확인"

ps -ef | grep -E "nfs|statd|lockd" | grep -v grep > /tmp/u24_nfs_check.txt

if [ -s /tmp/u24_nfs_check.txt ]; then
  echo "  [취약] NFS 관련 데몬 실행 중"
  cat /tmp/u24_nfs_check.txt
else
  echo "  [양호] NFS 관련 데몬 실행 안됨"
fi

rm -f /tmp/u24_nfs_check.txt
