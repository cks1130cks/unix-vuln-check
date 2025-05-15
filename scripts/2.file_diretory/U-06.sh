#!/bin/bash

echo "U-06: 파일 및 디렉토리 소유자 설정 점검"

# 소유자 또는 그룹이 없는 파일 및 디렉토리 찾기 (경로만 출력)
RESULT=$(find / \( -nouser -o -nogroup \) -print 2>/dev/null)

if [ -n "$RESULT" ]; then
  COUNT=$(echo "$RESULT" | wc -l)
  echo "  [취약] 총 $COUNT 개의 소유자/그룹 미설정 파일/디렉토리가 발견되었습니다."
  echo "  문제 파일/디렉토리 목록:"
  # 한 줄씩 출력 (while문 사용)
  echo "$RESULT" | while IFS= read -r line; do
    echo "    $line"
  done
else
  echo "  [양호] 소유자 및 그룹이 없는 파일 및 디렉토리가 없습니다."
fi
