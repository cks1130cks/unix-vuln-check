#!/bin/bash

echo "U-71: Apache 웹 서비스 정보 숨김"

# Apache 설정 파일 경로
apache_config_file="/etc/httpd/conf/httpd.conf"

if [ -f "$apache_config_file" ]; then
    # ServerTokens 설정 확인
    server_tokens=$(grep -Ei '^ServerTokens\s+' "$apache_config_file" | tail -n1)
    # ServerSignature 설정 확인
    server_signature=$(grep -Ei '^ServerSignature\s+' "$apache_config_file" | tail -n1)

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
