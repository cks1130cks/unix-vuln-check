#!/bin/bash

echo "U-16: /dev에 존재하지 않는 일반 파일 점검"

echo "  점검 대상: /dev 디렉토리 내 존재하는 일반 파일 여부 확인"

output=$(find /dev -type f 2>/dev/null)

if [ -z "$output" ]; then
    echo "  [양호] /dev 디렉토리에 일반 파일이 존재하지 않습니다."
else
    echo "  [취약] /dev 디렉토리에 일반 파일이 존재합니다."
    echo "         /dev에는 일반 파일이 존재하지 않아야 하며, 보안상 위험할 수 있습니다."
    echo "  발견 파일 목록:"
    echo "$output" | while read -r file; do
        echo "    - $file"
    done
fi
