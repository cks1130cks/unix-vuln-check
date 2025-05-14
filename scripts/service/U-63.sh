#!/bin/bash

echo "U-63: FTP 접근제어 설정파일에 관리자 외 비인가자들이 수정 제한 여부 점검"

# 1. ftpusers 파일 존재 여부 확인
ftpusers_file="/etc/ftpusers"
if [ ! -f "$ftpusers_file" ]; then
    echo "  [취약] /etc/ftpusers 파일이 존재하지 않습니다. 파일을 생성해야 합니다."
    exit 1
fi

# 2. ftpusers 파일의 소유자 및 권한 확인
file_owner=$(stat -c %U "$ftpusers_file")
file_permissions=$(stat -c %a "$ftpusers_file")

if [ "$file_owner" == "root" ] && [ "$file_permissions" -le 640 ]; then
    echo "  [양호] /etc/ftpusers 파일의 소유자가 root이고, 권한이 640 이하로 설정되어 있습니다."
else
    echo "  [취약] /etc/ftpusers 파일의 소유자가 root가 아니거나, 권한이 640 이하가 아닙니다."
    echo "       소유자를 root로 설정하고, 권한을 640 이하로 설정해야 합니다."
fi
