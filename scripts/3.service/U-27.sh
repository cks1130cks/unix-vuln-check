#!/bin/bash
echo "[U-27] RPC 서비스 확인"
rpcinfo -p 2>/dev/null > /tmp/u27_rpc.txt
if grep -qE 'rusersd|walld|sprayd|rstatd' /tmp/u27_rpc.txt; then
  echo "결과: 취약 (불필요한 RPC 서비스 사용 중)"
  grep -E 'rusersd|walld|sprayd|rstatd' /tmp/u27_rpc.txt
else
  echo "결과: 양호 (불필요한 RPC 서비스 사용 안함)"
fi
