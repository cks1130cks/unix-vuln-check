#!/bin/bash

echo "U-36: Apache 프로세스 권한 확인"
echo "  점검 파일: /etc/httpd/conf/httpd.conf"

USER=$(grep -i '^User' /etc/httpd/conf/httpd.conf 2>/dev/null | awk '{print $2}')

if [ -z "$USER" ]; then
    echo "  [취약] Apache User 설정을 찾을 수 없음"
else
    echo "  현재 Apache 실행 사용자: $USER"
    if [ "$USER" = "root" ]; then
        echo "  [취약] root 계정으로 실행 중"
    else
        echo "  [양호] 일반 계정으로 실행 중"
    fi
fi
