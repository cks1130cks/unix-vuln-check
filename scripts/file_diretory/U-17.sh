#!/bin/bash
echo "[U-17] $HOME/.rhosts, /etc/hosts.equiv 사용 금지 점검"
FILES=("$HOME/.rhosts" "/etc/hosts.equiv")
for FILE in "${FILES[@]}"; do
  if [ -f "$FILE" ]; then
    echo "결과: 취약 ($FILE 파일 존재)"
  else
    echo "결과: 양호 ($FILE 없음)"
  fi
done
