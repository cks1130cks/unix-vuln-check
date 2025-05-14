#!/bin/bash

echo "U-61: FTP 서비스 활성화 점검"

# 1. FTP 서비스 확인 (vsftpd)
ftp_status=$(systemctl is-active vsftpd)
if [ "$ftp_status" == "active" ]; then
    echo "  [취약] FTP 서비스(vsftpd)가 실행 중입니다. 보안상 취약하므로 서비스를 비활성화해야 합니다."
else
    echo "  [양호] FTP 서비스(vsftpd)가 실행 중이지 않습니다."
fi
