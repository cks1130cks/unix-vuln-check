#!/bin/bash

echo "U-24: NFS 서비스 비활성화 점검"
echo "  점검 내용: nfs, statd, lockd 데몬 실행 여부 확인"

# NFS 관련 데몬 프로세스 확인
ps -ef | grep -E "nfs|statd|lockd" | grep -v grep > /tmp/u24_nfs_check.txt

if [ -s /tmp/u24_nfs_check.txt ]; then
    echo "  [취약] NFS 관련 데몬이 실행 중입니다."
    echo "  실행 중인 프로세스 목록:"
    sed 's/^/    - /' /tmp/u24_nfs_check.txt  # 전부 출력
else
    echo "  [양호] NFS 관련 데몬이 실행되고 있지 않습니다."
fi

rm -f /tmp/u24_nfs_check.txt
