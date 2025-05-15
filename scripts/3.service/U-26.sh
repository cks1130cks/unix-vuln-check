#!/bin/bash
echo "U-26: automountd 제거 확인"

ps -ef | grep automountd | grep -v grep > /tmp/u26_auto.txt

if [ -s /tmp/u26_auto.txt ]; then
  echo "  [취약] automountd 데몬 실행 중"
  cat /tmp/u26_auto.txt
else
  echo "  [양호] automountd 미사용"
fi
