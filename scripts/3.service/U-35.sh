#!/bin/bash

echo "U-35: 디렉터리 리스팅 설정 확인"
echo "  점검 대상: /etc/httpd 하위 파일의 Options 설정"

# /etc/httpd 하위에서 Options 설정 중 Indexes 포함 여부 확인
options_with_indexes=$(grep -R "Options" /etc/httpd 2>/dev/null | grep 'Indexes')

if [ -n "$options_with_indexes" ]; then
    echo "  [취약] Indexes 설정이 발견되었습니다."
    echo "  발견된 설정 일부:"
    echo "$options_with_indexes" | head -n 10 | sed 's/^/    /'
else
    echo "  [양호] Indexes 설정이 없습니다."
fi
