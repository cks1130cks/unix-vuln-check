#!/bin/bash

echo "U-59: 숨겨진 파일 및 디렉토리 점검"
echo "  점검 대상: 시스템 전체 숨겨진 파일 및 디렉토리 ('.'로 시작하는 파일 및 폴더)"

# 숨겨진 파일 모두 검색 (권한 문제 등으로 에러는 무시)
hidden_files=$(find / -name ".*" 2>/dev/null)

# 총 개수 계산
count=$(echo "$hidden_files" | grep -c '^')

if [ "$count" -eq 0 ]; then
    echo "  [양호] 숨겨진 파일 및 디렉토리가 없습니다."
else
    echo "  [취약] 숨겨진 파일 및 디렉토리가 총 $count 개 발견되었습니다."
    echo "  상위 10개 목록:"
    echo "$hidden_files" | head -n 10 | sed 's/^/    - /'
    echo "  전체 목록은 /tmp/U-59_hidden_files.log 에 저장하였습니다."

    # 전체 결과 파일 저장
    echo "$hidden_files" > /tmp/U-59_hidden_files.log
fi
