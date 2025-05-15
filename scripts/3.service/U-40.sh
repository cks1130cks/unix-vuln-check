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
    echo "    - CGI 스크립트가 활성화되어 있을 경우, 파일 업로드 등 위험 가능성 존재"
else
    echo "    없음 (CGI 스크립트 실행 핸들러 설정 없음)"
fi

echo "  AllowOverride 설정 (디렉토리 권한 재정의 제한):"
if [ -n "$allow_override" ]; then
    echo "$allow_override" | sed 's/^/    /'
    echo "    - 'None'으로 설정되어 있어 .htaccess 파일에 의한 권한 변경이 차단됨 (보안 강화)"
else
    echo "    없음 (AllowOverride가 제한되지 않아 권한 변경 가능성 존재)"
fi

if [ -n "$upload_handler" ] && [ -z "$allow_override" ]; then
    echo "  [취약] CGI 스크립트 실행이 허용되고 AllowOverride 제한이 없어 업로드/다운로드 제한이 미흡합니다."
elif [ -n "$upload_handler" ] && [ -n "$allow_override" ]; then
    echo "  [주의] CGI 스크립트 실행이 활성화되어 있으나 AllowOverride가 제한되어 있어 일부 위험은 줄어듭니다."
else
    echo "  [양호] 업로드 및 다운로드 제한 설정이 적절하게 적용되어 있습니다."
fi
