#!/bin/bash
echo "U-40: 웹서비스 파일 업로드 및 다운로드 제한"
CONF="/etc/httpd/conf/httpd.conf"
if grep -qE "AddHandler.*cgi-script" $CONF && grep -q "AllowOverride None" $CONF; then
    echo "  [취약] (업로드 및 다운로드 제한 설정 미흡)"
else
    echo "  [양호] (적절한 업로드/다운로드 제한 설정 존재)"
fi
