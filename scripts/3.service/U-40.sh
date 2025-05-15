#!/bin/bash
echo "U-40: 웹서비스 파일 업로드 및 다운로드 제한 점검"
CONF="/etc/httpd/conf/httpd.conf"

echo "  점검 파일: $CONF"

if [ ! -f "$CONF" ]; then
    echo "  [정보] 설정 파일이 존재하지 않습니다. 점검 대상이 아님"
    exit 0
fi

# 업로드/다운로드 제한 관련 주요 설정 점검
upload_handler=$(grep -E "AddHandler.*cgi-script" "$CONF")
allow_override=$(grep "AllowOverride None" "$CONF")

echo "  AddHandler 설정 (CGI 스크립트 실행 핸들러):"
if [ -n "$upload_handler" ]; then
    echo "$upload_handler" | sed 's/^/    /'
    echo "    - CGI 스크립트 실행이 허용되어 있습니다."
else
    echo "    없음 (CGI 스크립트 실행 핸들러 설정 없음)"
fi

echo "  AllowOverride 설정 (디렉토리 권한 재정의 제한):"
if [ -n "$allow_override" ]; then
    echo "$allow_override" | sed 's/^/    /'
    echo "    - 권한 변경이 제한되어 있습니다."
else
    echo "    없음 (권한 변경 제한이 없습니다)"
fi

if [ -n "$upload_handler" ] && [ -z "$allow_override" ]; then
    echo "  [취약] CGI 실행이 허용되고 권한 변경 제한도 없어 파일 업로드 및 다운로드 제한이 미흡합니다."
else
    echo "  [양호] 업로드 및 다운로드 제한 설정이 적절히 적용되어 있습니다."
fi
