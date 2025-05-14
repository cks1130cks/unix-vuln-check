#!/bin/bash
echo "U-27: root 소유의 일반 파일 존재 여부 점검"

# /home 디렉토리 내에서 root 소유의 일반 파일 검색
find /home -type f -user root > /tmp/root_owned_in_home.txt

if [ -s /tmp/root_owned_in_home.txt ]; then
    echo "  [취약] 일반 사용자 홈에 root 소유 파일이 존재함"
    cat /tmp/root_owned_in_home.txt
else
    echo "  [양호] 일반 사용자 홈에 root 소유 파일이 없음"
fi
