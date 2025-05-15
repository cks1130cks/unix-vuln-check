#!/bin/bash
echo "U-33: DNS 서비스 미사용 확인"
if ps -ef | grep -v grep | grep -q named; then
    echo "  [취약] (named 프로세스 동작 중)"
else
    echo "  [양호] (DNS 서비스 미사용)"
fi
