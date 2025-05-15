#!/bin/bash

echo "U-59: 숨겨진 파일 및 디렉토리 점검"
echo "  점검 대상: 시스템 전체 숨겨진 파일 및 디렉토리 ('.'로 시작하는 파일 및 폴더)"

hidden_files=$(find / -name ".*" 2>/dev/null)

if [ -z "$hidden_files" ]; then
    echo "  [양호] 숨겨진 파일 및 디렉토리가 없습니다."
else
    echo "  [취약] 숨겨진 파일 및 디렉토리가 발견되었습니다."
    echo "  발견 목록:"
    echo "$hidden_files" | sed 's/^/    - /'
fi
