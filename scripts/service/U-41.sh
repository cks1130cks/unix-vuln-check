#!/bin/bash
echo "[U-41] 웹서비스 영역의 분리"
HTML_PATH="/var/www/html"
UPLOAD_PATH="/var/www/uploads"
if [ -d "$UPLOAD_PATH" ]; then
    echo "업로드 디렉터리 존재 확인됨: $UPLOAD_PATH"
    echo "결과: 양호 (업로드 영역이 분리되어 있음)"
else
    echo "결과: 취약 (웹서비스 업로드 디렉터리가 분리되어 있지 않음)"
fi
