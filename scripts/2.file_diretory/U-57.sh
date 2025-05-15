#!/bin/bash

echo "U-57: 홈 디렉토리 소유자 및 권한 설정 점검"

result="양호"

for dir in /home/*; do
    [ -d "$dir" ] || continue
    user=$(basename "$dir")
    owner=$(stat -c %U "$dir")
    perms=$(stat -c %a "$dir")
    others_write=$(( (perms % 10) & 2 ))

    if [ "$owner" != "$user" ] || [ "$others_write" -eq 2 ]; then
        echo "  [취약] $dir → 소유자: $owner, 권한: $perms (문제 있음)"
        result="취약"
    fi
done

if [ "$result" = "양호" ]; then
    echo "  [양호] 모든 홈 디렉토리의 소유자와 권한이 적절히 설정되어 있습니다."
fi
