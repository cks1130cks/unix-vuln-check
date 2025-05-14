#!/bin/bash

echo "U-64: FTP 서비스를 사용할 경우 ftpusers 파일에 root 계정 포함 여부 점검"

# 1. FTP 서비스 상태 확인
ftp_status=$(systemctl is-active vsftpd)

if [ "$ftp_status" != "active" ]; then
    echo "  [양호] FTP 서비스가 비활성화 되어 있습니다."
    exit 0
fi

# 2. FTP 서비스가 활성화된 경우 ftpusers 파일에서 root 계정 확인
ftpusers_file="/etc/ftpusers"
if [ -f "$ftpusers_file" ]; then
    if grep -q "^root" "$ftpusers_file"; then
        echo "  [취약] /etc/ftpusers 파일에 root 계정이 포함되어 있습니다. root 계정의 접속을 차단해야 합니다."
    else
        echo "  [양호] /etc/ftpusers 파일에 root 계정이 포함되어 있지 않습니다."
    fi
else
    echo "  [취약] /etc/ftpusers 파일이 존재하지 않습니다. 파일을 생성해야 합니다."
fi
