#!/bin/bash

# Apache 설정 파일 경로 (사용자 환경에 맞게 수정 필요)
APACHE_CONF="/etc/httpd/conf/httpd.conf"  # 일반적 Linux 경로 예시
# APACHE_CONF="/usr/local/apache/conf/httpd.conf"  # Solaris 등 다른 환경 예시

# 기본 DocumentRoot 경로 목록
DEFAULT_DOCROOTS=(
    "/usr/local/apache/htdocs"
    "/usr/local/apache2/htdocs"
    "/var/www/html"
)

echo "U-41 웹서비스 영역의 분리"
echo "Apache 설정 파일: $APACHE_CONF"

if [ ! -f "$APACHE_CONF" ]; then
    echo "[오류] Apache 설정 파일을 찾을 수 없습니다: $APACHE_CONF"
    exit 1
fi

# httpd.conf에서 DocumentRoot 설정 추출
DOCROOT=$(grep -i "^DocumentRoot" "$APACHE_CONF" | awk '{print $2}' | tr -d '"')

if [ -z "$DOCROOT" ]; then
    echo "[취약] DocumentRoot 설정이 없습니다."
    exit 1
fi

echo "현재 DocumentRoot: $DOCROOT"

# 기본 DocumentRoot 경로와 비교
IS_DEFAULT=0
for path in "${DEFAULT_DOCROOTS[@]}"; do
    if [ "$DOCROOT" == "$path" ]; then
        IS_DEFAULT=1
        break
    fi
done

if [ $IS_DEFAULT -eq 1 ]; then
    echo "[취약] DocumentRoot가 기본 경로로 설정되어 있습니다."
    echo "권장: /etc, /bin, /sbin, /usr 등 시스템 영역과 분리된 별도 디렉터리로 변경하세요."
else
    echo "[양호] DocumentRoot가 별도의 디렉터리로 설정되어 있습니다."
fi

echo "점검 종료."
