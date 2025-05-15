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
    server_tokens=$(grep -Ei '^\s*ServerTokens\s+' "$apache_config_file" | grep -v '^\s*#' | tail -n1)
    server_signature=$(grep -Ei '^\s*ServerSignature\s+' "$apache_config_file" | grep -v '^\s*#' | tail -n1)

    echo "  현재 설정된 Apache 보안 관련 지시어:"
    echo "    - ServerTokens: ${server_tokens:-설정 없음 또는 주석 처리됨}"
    echo "    - ServerSignature: ${server_signature:-설정 없음 또는 주석 처리됨}"

    if [[ "$server_tokens" =~ ^ServerTokens[[:space:]]+Prod$ ]] && [[ "$server_signature" =~ ^ServerSignature[[:space:]]+Off$ ]]; then
        echo "  [양호] ServerTokens이 'Prod', ServerSignature가 'Off'로 설정되어 있습니다."
        echo "    - 웹 서버 정보 노출이 최소화되어 보안상 안전한 상태입니다."
    else
        echo "  [취약] ServerTokens이 'Prod'가 아니거나 ServerSignature가 'Off'가 아닙니다."
        echo "    - Apache 버전 정보 또는 서버 정보가 외부에 노출될 수 있습니다."
        echo "    - 아래와 같이 설정 변경이 필요합니다:"
        echo "        ServerTokens Prod"
        echo "        ServerSignature Off"
        echo "    - 설정 후 Apache 서비스를 재시작하십시오: systemctl restart httpd 또는 apache2"
    fi
else
    echo "  [취약] Apache 설정 파일을 찾을 수 없습니다."
    echo "    - Apache가 설치되어 있지 않거나 비표준 경로에 설치되었을 수 있습니다."
fi
