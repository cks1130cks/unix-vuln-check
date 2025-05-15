#!/bin/bash

echo "U-58: 홈 디렉토리 존재 여부 점검"

echo "  점검 대상 파일: /etc/passwd"

while IFS=: read -r user pass uid gid full home shell; do
    # 홈 디렉터리가 존재하지 않는 경우 취약으로 출력
    if [ ! -d "$home" ]; then
        echo "  [취약] 홈 디렉터리 '$home'가 존재하지 않음 - 사용자: $user"
    fi
done < /etc/passwd
