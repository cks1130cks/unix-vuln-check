#!/bin/bash
echo "[U-28] NIS 서비스 비활성화"
if ps -ef | grep -E "ypbind|rpc.yppasswdd|ypserv|ypset" | grep -v grep > /dev/null; then
    echo "결과: 취약 (NIS 관련 프로세스 실행 중)"
else
    echo "결과: 양호 (NIS 비활성화)"
fi
