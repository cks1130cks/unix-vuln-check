#!/bin/bash
echo "U-28: NIS 서비스 비활성화 점검"

# NIS 관련 프로세스 실행 중인지 확인
if ps -ef | grep -E "ypbind|rpc.yppasswdd|ypserv|ypset" | grep -v grep > /dev/null; then
    echo "  [취약] NIS 관련 프로세스가 실행 중"
else
    echo "  [양호] NIS 서비스가 비활성화됨"
fi
