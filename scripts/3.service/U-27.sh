#!/bin/bash

echo "U-27: RPC 서비스 확인"
echo "  점검 내용: 불필요한 RPC 서비스(rusersd, walld, sprayd, rstatd) 실행 여부 확인"

# RPC 서비스 목록 추출
rpcinfo -p 2>/dev/null > /tmp/u27_rpc.txt

if grep -qE 'rusersd|walld|sprayd|rstatd' /tmp/u27_rpc.txt; then
    echo "  [취약] 불필요한 RPC 서비스가 실행 중입니다."
    echo "  실행 중인 서비스:"
    grep -E 'rusersd|walld|sprayd|rstatd' /tmp/u27_rpc.txt | sed 's/^/    - /'
else
    echo "  [양호] 불필요한 RPC 서비스가 실행되고 있지 않습니다."
fi

rm -f /tmp/u27_rpc.txt
