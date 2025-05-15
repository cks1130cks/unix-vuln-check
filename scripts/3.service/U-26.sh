#!/bin/bash
echo "U-26: automountd/automount 제거 확인"

echo "  프로세스명: automountd, automount"

ps -ef | grep -E 'automountd|automount' | grep -v grep > /tmp/u26_auto.txt

if [ -s /tmp/u26_auto.txt ]; then
  echo "  [취약] automountd 또는 automount 데몬이 실행 중입니다."
  cat /tmp/u26_auto.txt
else
  echo "  [양호] automountd 및 automount 데몬이 실행 중이지 않습니다."
fi
