#!/bin/bash
echo "[U-27] root 소유의 일반파일 존재 확인"
find /home -type f -user root > /tmp/root_owned_in_home.txt
if [ -s /tmp/root_owned_in_home.txt ]; then
    echo "결과: 취약 (일반 사용자 홈에 root 소유 파일 존재)"
    cat /tmp/root_owned_in_home.txt
else
    echo "결과: 양호"
fi
