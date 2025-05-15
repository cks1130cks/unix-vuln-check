#!/bin/bash

echo "U-71: Apache 웹 서비스 정보 숨김"

apache_config_file="/etc/httpd/conf/httpd.conf"

if [ -f "$apache_config_file" ]; then
    # ServerTokens 설정 (주석 제외)
    server_tokens=$(grep -Ei '^\s*ServerTokens\s+' "$apache_config_file" | grep -v '^\s*#' | tail -n1)
    # ServerSignature 설정 (주석 제외)
    server_signature=$(grep -Ei '^\s*ServerSignature\s+' "$apache_config_file" | grep -v '^\s*#' | tail -n1)

    # 없으면 명확히 표시
    if [ -z "$server_tokens" ]; then
        server_tokens="(설정 없음 또는 주석 처리됨)"
    fi
    if [ -z "$server_signature" ]; then
        server_signature="(설정 없음 또는 주석 처리됨)"
    fi

    if [[ "$server_tokens" =~ ^ServerTokens[[:space:]]+Prod$ ]] && [[ "$server_signature" =~ ^ServerSignature[[:space:]]+Off$ ]]; then
        echo "  [양호] ServerTokens Prod, ServerSignature Off로 설정되어 있습니다."
    else
        echo "  [취약] ServerTokens Prod, ServerSignature Off로 설정되어 있지 않습니다."
        echo "    현재 설정:"
        echo "      $server_tokens"
        echo "      $server_signature"
    fi
else
    echo "  [취약] Apache 설정 파일($apache_config_file)이 존재하지 않습니다."
fi
