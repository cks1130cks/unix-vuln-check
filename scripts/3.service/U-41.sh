#!/bin/bash

echo "U-41: 웹 서비스 영역의 분리 점검"

# Apache 설정 파일에서 DocumentRoot 추출
docroot=$(grep -i '^DocumentRoot' /etc/httpd/conf/httpd.conf | awk '{print $2}' | tr -d '"')

# 시스템 중요 디렉터리 목록
unsafe_dirs=("/" "/bin" "/sbin" "/etc" "/usr" "/lib" "/lib64" "/boot" "/dev")

# 결과 판단
if [ -z "$docroot" ]; then
    echo "  [취약] DocumentRoot 설정을 찾을 수 없습니다."
elif [[ " ${unsafe_dirs[@]} " =~ " ${docroot} " ]]; then
    echo "  [취약] DocumentRoot가 시스템 디렉터리(${docroot})로 설정되어 있습니다."
else
    echo "  DocumentRoot 설정: $docroot"
    echo "  [양호] DocumentRoot가 전용 웹 디렉터리로 설정되어 있습니다."
fi
