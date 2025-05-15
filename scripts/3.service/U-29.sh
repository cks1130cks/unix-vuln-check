#!/bin/bash
echo "U-29: tftp, talk 서비스 비활성화 점검"

if [ -f /etc/xinetd.d/tftp ] || [ -f /etc/xinetd.d/talk ]; then
  echo "  [취약] tftp 또는 talk 서비스 파일 존재"
else
  echo "  [양호] tftp 및 talk 서비스 없음"
fi
