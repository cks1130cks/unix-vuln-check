#!/bin/bash
echo "U-38: Apache manual 디렉터리 존재 확인"
echo "  점검 대상 디렉터리:"
echo "    /var/www/manual"
echo "    /var/www/html/manual"

found_dirs=()

for dir in /var/www/manual /var/www/html/manual; do
    if [ -d "$dir" ]; then
        found_dirs+=("$dir")
    fi
done

if [ ${#found_dirs[@]} -eq 0 ]; then
    echo "  [양호] manual 디렉터리가 존재하지 않습니다."
else
    echo "  [취약] 다음 manual 디렉터리가 발견되었습니다:"
    for d in "${found_dirs[@]}"; do
        echo "    - $d"
    done
    echo "  불필요한 디렉터리는 삭제하거나 접근 제한 조치가 필요합니다."
fi
