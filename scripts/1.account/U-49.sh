#!/bin/bash
echo "U-19: finger 서비스 비활성화 점검"

FILE="/etc/xinetd.d/finger"

if [ -f "$FILE" ]; then
  DISABLE=$(grep -i '^disable' "$FILE" | awk '{print $3}')
  if [ "$DISABLE" == "no" ]; then
    echo "  [취약] finger 서비스가 활성화 되어 있음 (disable = no)"
  else
    echo "  [양호] finger 서비스가 비활성화 되어 있음 (disable = yes 또는 설정 없음)"
  fi
else
  echo "  [양호] finger 서비스 설정 파일 없음"
fi
