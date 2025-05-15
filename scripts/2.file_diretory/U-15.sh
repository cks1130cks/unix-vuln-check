#!/bin/bash

echo "U-15: 불필요한 world writable 파일 존재 여부 점검"

echo "  점검 대상: 루트 파일 시스템(/) 내 스티키 비트가 설정되지 않은 world writable 일반 파일"

output=$(find / -xdev -type f -perm -002 ! -perm -1000 2>/dev/null)

if [ -z "$output" ]; then
    echo "  [양호] 불필요한 world writable 파일이 존재하지 않습니다."
else
    echo "  [취약] 다음과 같은 불필요한 world writable 파일이 존재합니다."
    echo "         보안 위험을 초래할 수 있으니 권한 수정이 필요합니다."
    echo "  발견 파일 목록:"
    echo "$output" | while read -r file; do
        echo "    - $file"
    done
fi
