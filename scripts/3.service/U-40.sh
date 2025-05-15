#!/bin/bash
echo "U-40: 웹서비스 파일 업로드 및 다운로드 제한 점검"
CONF="/etc/httpd/conf/httpd.conf"
UPLOAD_DIR="/var/www/html/uploads"
MAX_SIZE=5242880  # 5MB in bytes
ALLOWED_EXTENSIONS="jpg png txt"

echo "  점검 파일: $CONF"

if [ ! -f "$CONF" ]; then
    echo "  [정보] 설정 파일이 존재하지 않습니다. 점검 대상이 아님"
    exit 0
fi

upload_handler=$(grep -E "AddHandler.*cgi-script" "$CONF")
allow_override=$(grep "AllowOverride None" "$CONF")
limit_request_body=$(grep -i "^\s*LimitRequestBody" "$CONF" | tail -n 1)

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

echo "  LimitRequestBody 설정 (파일 업로드 크기 제한):"
if [ -n "$limit_request_body" ]; then
    echo "    $limit_request_body"
    # LimitRequestBody 값 추출 (숫자)
    limit_value=$(echo "$limit_request_body" | awk '{print $2}')
    if [[ "$limit_value" =~ ^[0-9]+$ ]]; then
        if [ "$limit_value" -le "$MAX_SIZE" ]; then
            echo "    - 5MB 이하로 제한되어 있어 적절합니다."
            limit_flag=true
        else
            echo "    - 5MB 초과 제한값으로 설정되어 있어 취약할 수 있습니다."
            limit_flag=false
        fi
    else
        echo "    - LimitRequestBody 값이 숫자가 아닙니다. 설정 확인 필요."
        limit_flag=false
    fi
else
    echo "    없음 (파일 업로드 크기 제한이 설정되어 있지 않습니다.)"
    limit_flag=false
fi

# 업로드 디렉터리 정책 점검
if [ -d "$UPLOAD_DIR" ]; then
    echo "  업로드 디렉터리 존재: $UPLOAD_DIR"

    # 5MB 초과 파일 점검
    large_files=$(find "$UPLOAD_DIR" -type f -size +"$MAX_SIZE"c)
    if [ -n "$large_files" ]; then
        echo "  [취약] 5MB 초과 대용량 파일이 존재합니다:"
        echo "$large_files" | sed 's/^/    /'
        large_files_flag=true
    else
        echo "  5MB 초과 대용량 파일 없음"
        large_files_flag=false
    fi

    # 확장자 화이트리스트 점검
    invalid_files=$(find "$UPLOAD_DIR" -type f ! \( $(printf -- "-iname '*.%s' -o " $ALLOWED_EXTENSIONS) -false \))
    if [ -n "$invalid_files" ]; then
        echo "  [취약] 허용되지 않은 확장자 파일이 존재합니다:"
        echo "$invalid_files" | sed 's/^/    /'
        invalid_files_flag=true
    else
        echo "  허용된 확장자 파일만 존재"
        invalid_files_flag=false
    fi
else
    echo "  [정보] 업로드 디렉터리($UPLOAD_DIR)가 존재하지 않아 업로드 파일 정책 점검 불가"
    large_files_flag=false
    invalid_files_flag=false
fi

# 최종 판단
if [ -n "$upload_handler" ] && [ -z "$allow_override" ] && $limit_flag && ! $large_files_flag && ! $invalid_files_flag ; then
    echo "  [양호] 업로드 및 다운로드 제한 설정과 파일 정책이 적절히 적용되어 있습니다."
else
    echo "  [취약] 업로드 및 다운로드 제한 또는 파일 정책이 미흡합니다."
fi
