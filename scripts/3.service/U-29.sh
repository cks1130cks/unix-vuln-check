#!/bin/bash

echo "U-29: tftp, talk, ntalk 서비스 비활성화 점검"

# 1. /etc/inetd.conf 점검 (SOLARIS 5.9 이하, AIX, HP-UX, 일부 Linux)
echo "  [1] /etc/inetd.conf 내 tftp, talk, ntalk 서비스 설정 확인"
grep -E '^\s*(tftp|talk|ntalk)' /etc/inetd.conf > /tmp/u29_inetd.txt 2>/dev/null

if [ -s /tmp/u29_inetd.txt ]; then
  echo "  [취약] /etc/inetd.conf 파일에 활성화된 서비스가 존재합니다."
  cat /tmp/u29_inetd.txt
else
  echo "  [양호] /etc/inetd.conf 파일에 해당 서비스 활성화 설정이 없습니다."
fi

# 2. /etc/xinetd.d 디렉터리 내 서비스 비활성화 여부 확인 (Linux, AIX, HP-UX xinetd 환경)
echo "  [2] /etc/xinetd.d/ 내 tftp, talk, ntalk 서비스 disable 설정 확인"
for svc in tftp talk ntalk; do
  if [ -f "/etc/xinetd.d/$svc" ]; then
    grep -i '^disable\s*=\s*yes' "/etc/xinetd.d/$svc" > /dev/null
    if [ $? -eq 0 ]; then
      echo "    [양호] $svc 서비스가 비활성화(disable=yes) 되어 있습니다."
    else
      echo "    [취약] $svc 서비스가 활성화되어 있거나 disable 설정이 없습니다: /etc/xinetd.d/$svc"
    fi
  else
    echo "    [정보] /etc/xinetd.d/$svc 파일이 존재하지 않습니다."
  fi
done

# 3. Solaris 5.10 이상: SMF 서비스 상태 점검
if command -v inetadm >/dev/null 2>&1; then
  echo "  [3] Solaris 5.10 이상 서비스 상태 점검 (inetadm 명령어 활용)"
  for svc in svc:/network/tftp:default svc:/network/talk:default svc:/network/ntalk:default; do
    inetadm -l | grep -F "$svc" | grep enabled > /tmp/u29_smf.txt
    if [ -s /tmp/u29_smf.txt ]; then
      echo "    [취약] $svc 서비스가 활성화 되어 있습니다."
      cat /tmp/u29_smf.txt
    else
      echo "    [양호] $svc 서비스가 비활성화 되어 있습니다."
    fi
    rm -f /tmp/u29_smf.txt
  done
fi

