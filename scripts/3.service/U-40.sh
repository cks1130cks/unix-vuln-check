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

echo "  AddHandler 설정:"
if [ -n "$upload_handler" ]; then
    echo "$upload_handler" | sed 's/^/    /'
else
    echo "    없음"
fi

echo "  AllowOverride 설정:"
if [ -n "$allow_override" ]; then
    echo "$allow_override" | sed 's/^/    /'
else
    echo "    없음"
fi

if [ -n "$upload_handler" ] && [ -n "$allow_override" ]; then
    echo "  [취약] 업로드 및 다운로드 제한 설정이 미흡합니다."
else
    echo "  [양호] 적절한 업로드 및 다운로드 제한 설정이 존재합니다."
fi
