#!/bin/bash
echo "U-36: Apache 프로세스 권한 확인"
USER=$(grep -i '^User' /etc/httpd/conf/httpd.conf 2>/dev/null | awk '{print $2}')
if [ "$USER" = "root" ]; then
    echo "  [취약] (root 계정으로 실행 중)"
else
    echo "  [양호] (일반 계정으로 실행 중)"
fi
