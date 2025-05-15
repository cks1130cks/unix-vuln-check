#!/bin/bash

echo "U-33: DNS 서비스 미사용 확인"
echo "  점검 프로세스: named"

if ps -ef | grep -v grep | grep -q named; then
    echo "  [취약] named 프로세스가 실행 중입니다."
    echo "  실행 중인 named 프로세스 정보:"
    ps -ef | grep named | grep -v grep | sed 's/^/    /'
else
    echo "  [양호] DNS 서비스(named) 미사용 상태입니다."
fi
