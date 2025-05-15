#!/bin/bash

echo "U-28: NIS, NIS+ 서비스 점검"
echo "  점검 내용: ypbind, rpc.yppasswdd, ypserv, ypset 데몬 실행 여부 확인"

# NIS 관련 데몬 프로세스 확인
ps -ef | grep -E "ypbind|rpc.yppasswdd|ypserv|ypset" | grep -v grep > /tmp/u28_nis.txt

if [ -s /tmp/u28_nis.txt ]; then
    echo "  [취약] NIS 관련 데몬이 실행 중입니다."
    echo "  실행 중인 프로세스:"
    cat /tmp/u28_nis.txt | sed 's/^/    - /'
else
    echo "  [양호] NIS 관련 데몬이 실행되고 있지 않습니다."
fi

rm -f /tmp/u28_nis.txt
