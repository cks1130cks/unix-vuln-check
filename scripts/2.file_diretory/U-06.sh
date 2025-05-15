#!/bin/bash

echo "U-06: 파일 및 디렉토리 소유자 설정"

# 소유자나 그룹이 없는 파일 찾기
RESULT=$(find / \( -nouser -o -nogroup \) -ls 2>/dev/null)

if [ -n "$RESULT" ]; then
  echo "  [취약] (소유자가 존재하지 않은 파일 및 디렉토리가 있습니다.)"
else
  echo "  [양호] (소유자가 존재하지 않은 파일 및 디렉토리가 없습니다.)"
fi
