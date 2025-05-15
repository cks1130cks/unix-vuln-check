#!/bin/bash

echo "U-21: r 계열 서비스 비활성화 점검"

CHECK_FILES=("/etc/xinetd.d/rlogin" "/etc/xinetd.d/rsh")

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
  echo "  [취약] r 계열 서비스 관련 파일 존재"
else
  echo "  [양호] r 계열 서비스 관련 파일 없음"
fi
