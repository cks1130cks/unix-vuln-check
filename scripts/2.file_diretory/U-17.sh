#!/bin/bash

echo "U-17: 사용자 홈 디렉터리 내 .rhosts 파일 및 /etc/hosts.equiv 사용 금지 점검"

FILES=("$HOME/.rhosts" "/etc/hosts.equiv")

for FILE in "${FILES[@]}"; do
  if [ -f "$FILE" ]; then
    echo "  [취약] $FILE 파일이 존재합니다."
  else
    echo "  [양호] $FILE 파일이 존재하지 않습니다."
  fi
done
