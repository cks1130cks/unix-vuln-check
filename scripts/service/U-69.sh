#!/bin/bash

echo "U-69: NFS 접근제어 설정파일에 대한 비인가자들의 수정 제한 여부 점검"

# NFS 접근 제어 설정 파일 경로
nfs_config_file="/etc/exports"

# NFS 접근 제어 설정 파일의 소유자와 권한 확인
if [ -f "$nfs_config_file" ]; then
    file_owner=$(stat -c %U "$nfs_config_file")
    file_permissions=$(stat -c %a "$nfs_config_file")

    if [ "$file_owner" = "root" ] && [ "$file_permissions" -le 644 ]; then
        echo "  [양호] NFS 접근제어 설정파일의 소유자가 root이고 권한이 644 이하입니다."
    else
        echo "  [취약] NFS 접근제어 설정파일의 소유자가 root가 아니거나 권한이 644 이하가 아닙니다."
    fi
else
    echo "  [취약] NFS 접근제어 설정파일($nfs_config_file)이 존재하지 않습니다."
fi
