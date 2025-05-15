#!/bin/bash

echo "U-71: Apache 웹 서비스 정보 숨김 설정 여부 점검"

# Apache 설정 파일 후보 목록
config_candidates=(
    "/etc/httpd/conf/httpd.conf"
    "/etc/apache2/apache2.conf"
    "/usr/local/apache2/conf/httpd.conf"
)

# 설정 파일 탐색
apache_config_file=""
for file in "${config_candidates[@]}"; do
    if [ -f "$file" ]; then
        apache_config_file="$file"
        break
    fi
done

if [ -n "$apache_config_file" ]; then
    echo "  Apache 설정 파일 위치: $apache_config_file"

    # ServerTokens 및 ServerSignature 설정 (주석 제외)
    server_tokens_line=$(grep -Ei '^\s*ServerTokens\s+' "$apache_config_file" | grep -v '^\s*#' | tail -n1)
    server_signature_line=$(grep -Ei '^\s*ServerSignature\s+' "$apache_config_file" | grep -v '^\s*#' | tail -n1)

    # 기본값 처리
    server_tokens_value=${server_tokens_line:-"설정 없음 또는 주석 처리됨"}
    server_signature_value=${server_signature_line:-"설정 없음 또는 주석 처리됨"}

    echo "  현재 설정된 Apache 보안 관련 지시어:"
    
    if [[ "$server_tokens_value" =~ ^ServerTokens[[:space:]]+Prod$ ]]; then
        echo "    [양호] ServerTokens: $server_tokens_value"
        server_tokens_ok=true
    else
        echo "    [취약] ServerTokens: $server_tokens_value"
        server_tokens_ok=false
    fi

    if [[ "$server_signature_value" =~ ^ServerSignature[[:space:]]+Off$ ]]; then
        echo "    [양호] ServerSignature: $server_signature_value"
        server_signature_ok=true
    else
        echo "    [취약] ServerSignature: $server_signature_value"
        server_signature_ok=false
    fi

    if ! $server_tokens_ok || ! $server_signature_ok; then
        echo ""
        echo "    - 아래와 같이 설정 변경이 필요합니다:"
        echo "        ServerTokens Prod"
        echo "        ServerSignature Off"
        echo "    - 설정 후 Apache 서비스를 재시작하십시오: systemctl restart httpd 또는 apache2"
    fi

else
    echo "  [취약] Apache 설정 파일을 찾을 수 없습니다."
    echo "    - Apache가 설치되어 있지 않거나 비표준 경로에 설치되었을 수 있습니다."
fi
