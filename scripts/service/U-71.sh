#!/bin/bash

echo "U-71: Apache 웹 서비스 정보 숨김"

# Apache 설정 파일 경로
apache_config_file="/etc/httpd/conf/httpd.conf"

# ServerTokens 및 ServerSignature 설정 확인
if grep -q "ServerTokens Prod" "$apache_config_file" && grep -q "ServerSignature Off" "$apache_config_file"; then
    echo "  [양호] ServerTokens Prod, ServerSignature Off로 설정되어 있습니다."
else
    echo "  [취약] ServerTokens Prod, ServerSignature Off로 설정되어 있지 않습니다."
fi
