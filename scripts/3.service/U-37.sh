#!/bin/bash

echo "U-37: 웹서비스 상위 디렉토리 접근 금지 점검"

HTTPD_CONF="/etc/httpd/conf/httpd.conf"  # 아파치 설정 파일 경로 (환경에 맞게 수정)

if [ ! -f "$HTTPD_CONF" ]; then
  echo "  [정보] Apache 설정 파일($HTTPD_CONF)이 존재하지 않습니다. 점검 대상 아님"
  exit 0
fi

echo "  점검 파일: $HTTPD_CONF"

# AllowOverride 설정 확인 (None인지, 아니면 AuthConfig/All로 되어있는지)
allow_override=$(grep -i 'AllowOverride' "$HTTPD_CONF" | grep -v '^#' | tail -n 10)

if echo "$allow_override" | grep -q -i "None"; then
  echo "  [취약] AllowOverride가 None으로 설정되어 있어 상위 디렉토리 접근 제한 미설정 가능성 있음"
  echo "         사용자 인증용 .htaccess 적용이 되지 않을 수 있음"
else
  echo "  [양호] AllowOverride가 None이 아니며, 사용자 인증을 위한 설정 가능"
fi

echo
echo "  * 추가 조치 방법"
echo "    1) AllowOverride None -> AuthConfig 또는 All로 변경"
echo "    2) 보호할 디렉토리에 .htaccess 파일 생성 및 사용자 인증 설정"
echo "    3) htpasswd 명령어로 인증 사용자 계정 생성"
