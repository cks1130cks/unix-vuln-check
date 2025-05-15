#!/bin/bash

echo "U-63: FTP 접근제어 설정파일에 관리자 외 비인가자들이 수정 제한 여부 점검"

# 점검 대상 파일 목록
ftp_files=(
    "/etc/ftpusers"
    "/etc/ftpd/ftpusers"
    "/etc/vsftpd/ftpusers"
    "/etc/vsftpd/user_list"
    "/etc/vsftpd.ftpusers"
    "/etc/vsftpd.user_list"
)

vulnerable=0
found=0

for file in "${ftp_files[@]}"; do
    if [ -f "$file" ]; then
        found=1
        owner=$(stat -c %U "$file")
        perm=$(stat -c %a "$file")

        echo "  ▷ 파일 확인: $file"
        echo "    - 소유자: $owner"
        echo "    - 권한: $perm"

        if [ "$owner" = "root" ] && [ "$perm" -le 640 ]; then
            echo "    [양호] 소유자가 root이고 권한이 640 이하로 적절히 설정되어 있습니다."
        else
            echo "    [취약] 소유자가 root가 아니거나 권한이 640보다 높게 설정되어 있습니다."
            echo "         (소유자를 root로 설정하고 권한을 640 이하로 조정해야 합니다)"
            vulnerable=1
        fi
    fi
done

if [ $found -eq 0 ]; then
    echo "  [취약] 접근제어 파일이 하나도 존재하지 않습니다. FTP 설정을 확인하십시오."
    vulnerable=1
fi

if [ $vulnerable -eq 0 ]; then
    echo "  전반적으로 접근제어 설정이 적절히 되어 있습니다."
fi
