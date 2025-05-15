#!/bin/bash
echo "U-39: FollowSymLinks 설정 확인"
echo "  점검 대상 파일: /etc/httpd 내 설정 파일들"

found_files=$(grep -Rl "FollowSymLinks" /etc/httpd 2>/dev/null)

if [ -z "$found_files" ]; then
    echo "  [양호] FollowSymLinks 설정이 존재하지 않습니다."
else
    echo "  [취약] FollowSymLinks 설정이 발견된 파일:"
    echo "$found_files" | sed 's/^/    - /'
    echo "  필요 시 설정 제거 또는 수정이 필요합니다."
fi
