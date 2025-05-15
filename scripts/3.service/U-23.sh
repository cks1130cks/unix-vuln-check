#!/bin/bash

echo "U-23: Dos 공격에 취약한 서비스 비활성화 점검"

CHECK_FILES=(
  "/etc/xinetd.d/echo"
  "/etc/xinetd.d/discard"
  "/etc/xinetd.d/daytime"
)

echo "  점검 대상 파일:"
for file in "${CHECK_FILES[@]}"; do
  echo "    - $file"
done

found=0
for file in "${CHECK_FILES[@]}"; do
  if [ -f "$file" ]; then
    found=1
    break
  fi
done

if [ "$found" -eq 1 ]; then
  echo "  [취약] 취약한 echo/discard/daytime 서비스 파일 존재"
else
  echo "  [양호] 취약 서비스 비활성화 상태"
fi
