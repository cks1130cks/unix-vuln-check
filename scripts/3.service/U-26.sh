#!/bin/bash

echo "U-26: 불필요한 RPC 서비스 실행 여부 점검"

# 점검할 RPC 서비스 목록 (취약점 보고서에 명시된 서비스)
RPC_SERVICES=(
  "rpc.cmsd"
  "rpc.ttdbserverd"
  "sadmind"
  "rusersd"
  "walld"
  "sprayd"
  "rstatd"
  "rpc.nisd"
  "rexd"
  "rpc.pcnfsd"
  "rpc.statd"
  "rpc.ypupdated"
  "rpc.rquotad"
  "kcms_server"
  "cachefsd"
)

# 1. inetd.conf 파일 점검 (inetd 사용 시스템)
if [ -f /etc/inetd.conf ]; then
  echo "  [inetd.conf 파일 점검]"
  for svc in "${RPC_SERVICES[@]}"; do
    grep -E "^\s*${svc}" /etc/inetd.conf | grep -v '^#' > /dev/null
    if [ $? -eq 0 ]; then
      echo "  [취약] $svc 서비스가 /etc/inetd.conf 에서 활성화 되어있음"
    fi
  done
else
  echo "  /etc/inetd.conf 파일이 존재하지 않음, inetd 미사용 가능성"
fi

# 2. xinetd 서비스 점검 (xinetd 사용 시스템)
if [ -d /etc/xinetd.d ]; then
  echo "  [xinetd 서비스 점검]"
  for svc in "${RPC_SERVICES[@]}"; do
    for file in /etc/xinetd.d/*; do
      grep -q "$svc" "$file"
      if [ $? -eq 0 ]; then
        # 파일에서 disable 상태 확인
        grep -E "^\s*disable\s*=\s*yes" "$file" > /dev/null
        if [ $? -ne 0 ]; then
          echo "  [취약] $svc 서비스가 $file 에서 비활성화 되어있지 않음"
        fi
      fi
    done
  done
else
  echo "  /etc/xinetd.d 디렉터리가 존재하지 않음, xinetd 미사용 가능성"
fi

# 3. 실행중인 rpc 관련 데몬 점검 (솔라리스 5.10 이상, systemd, 기타)
echo "  [실행 중인 rpc 관련 데몬 점검]"
for svc in "${RPC_SERVICES[@]}"; do
  ps -ef | grep "$svc" | grep -v grep > /dev/null
  if [ $? -eq 0 ]; then
    echo "  [취약] $svc 프로세스가 실행 중임"
  fi
done