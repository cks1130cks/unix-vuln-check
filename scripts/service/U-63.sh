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

# 점검 수행
vulnerable=0

for file in "${ftp_files[@]}"; do
    if [ -f "$file" ]; then
        owner=$(stat -c %U "$file")
        perm=$(stat -c %a "$file")

        echo "  ▷ 파일 확인: $file"
        if [ "$owner" = "root" ] && [ "$perm" -le 640 ]; then
            echo "    [양호] 소유자: $owner, 권한: $perm (조건 만족)"
        else
            echo "    [취약] 소유자: $owner, 권한: $perm (소유자를 root로 설정하고 권한을 640 이하로 조정해야 합니다)"
            vulnerable=1
        fi
    fi
done

# 접근제어 파일이 아예 존재하지 않을 경우도 취약 처리
if [ $vulnerable -eq 0 ]; then
    found=0
    for file in "${ftp_files[@]}"; do
        if [ -f "$file" ]; then
            found=1
            break
        fi
    done

    if [ $found -eq 0 ]; then
        echo "  [취약] 접근제어 파일이 하나도 존재하지 않습니다. FTP 설정을 확인하십시오."
    fi
fi
