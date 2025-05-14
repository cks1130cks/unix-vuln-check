#!/bin/bash

echo "U-64: FTP 서비스를 사용할 경우 ftpusers 파일에 root 계정 포함 여부 점검"

# 1. FTP 서비스 상태 확인 (vsftpd, proftpd, ftpd 등)
ftp_services=("vsftpd" "proftpd" "pure-ftpd" "ftpd")
ftp_active=0

for service in "${ftp_services[@]}"; do
    if systemctl is-active --quiet "$service"; then
        echo "  ▷ 활성화된 FTP 서비스: $service"
        ftp_active=1
        break
    fi
done

if [ "$ftp_active" -eq 0 ]; then
    echo "  [양호] FTP 서비스가 비활성화 되어 있습니다."
    exit 0
fi

# 2. 점검 대상 파일 목록
ftp_files=(
    "/etc/ftpusers"
    "/etc/ftpd/ftpusers"
    "/etc/vsftpd/ftpusers"
    "/etc/vsftpd/user_list"
    "/etc/vsftpd.ftpusers"
    "/etc/vsftpd.user_list"
)

found_file=0
secure=1

for file in "${ftp_files[@]}"; do
    if [ -f "$file" ]; then
        found_file=1
        echo "  ▷ 파일 확인: $file"
        if grep -Eq "^root$|^root\s" "$file"; then
            echo "    [양호] $file 파일에 root 계정이 포함되어 있어 접속이 차단됩니다."
        else
            echo "    [취약] $file 파일에 root 계정이 포함되어 있지 않습니다. root 계정 접속을 차단해야 합니다."
            secure=0
        fi
    fi
done

if [ "$found_file" -eq 0 ]; then
    echo "  [취약] FTP 접근제어 파일이 존재하지 않습니다. 접속 차단 설정이 누락되었을 수 있습니다."
elif [ "$secure" -eq 1 ]; then
    echo "  [양호] 모든 FTP 접근제어 파일에 root 계정이 포함되어 있습니다."
fi
