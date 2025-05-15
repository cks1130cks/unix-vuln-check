#!/bin/bash
echo "U-41: 웹서비스 영역의 분리 점검"

HTML_PATH="/var/www/html"
UPLOAD_PATH="/var/www/uploads"

echo "  점검 대상 디렉터리:"
echo "    - 웹서비스 기본 경로: $HTML_PATH"
echo "    - 업로드 디렉터리: $UPLOAD_PATH"

if [ -d "$UPLOAD_PATH" ]; then
    echo "  [양호] 업로드 디렉터리가 별도로 분리되어 있음"
else
    echo "  [취약] 웹서비스 업로드 디렉터리가 분리되어 있지 않음"
fi
