#!/bin/bash

echo "U-65: 관리자(root)만 at.allow 파일과 at.deny 파일을 제어할 수 있는지 점검"

# at.allow 및 at.deny 파일 경로 정의
at_allow_file="/etc/at.allow"
at_deny_file="/etc/at.deny"

# 1. at.allow 파일 존재 여부 확인
if [ -f "$at_allow_file" ]; then
    file_owner=$(stat -c %U "$at_allow_file")
    file_permissions=$(stat -c %a "$at_allow_file")
    
    # 2. at.allow 파일 소유자 및 권한 확인
    if [ "$file_owner" == "root" ] && [ "$file_permissions" -le 640 ]; then
        echo "  [양호] /etc/at.allow 파일의 소유자가 root이고, 권한이 640 이하로 설정되어 있습니다."
    else
        echo "  [취약] /etc/at.allow 파일의 소유자가 root가 아니거나, 권한이 640 이하가 아닙니다."
        echo "       소유자를 root로 설정하고, 권한을 640 이하로 설정해야 합니다."
    fi
else
    echo "  [취약] /etc/at.allow 파일이 존재하지 않습니다. 파일을 생성해야 합니다."
fi

# 3. at.deny 파일 존재 여부 확인
if [ -f "$at_deny_file" ]; then
    file_owner=$(stat -c %U "$at_deny_file")
    file_permissions=$(stat -c %a "$at_deny_file")
    
    # 4. at.deny 파일 소유자 및 권한 확인
    if [ "$file_owner" == "root" ] && [ "$file_permissions" -le 640 ]; then
        echo "  [양호] /etc/at.deny 파일의 소유자가 root이고, 권한이 640 이하로 설정되어 있습니다."
    else
        echo "  [취약] /etc/at.deny 파일의 소유자가 root가 아니거나, 권한이 640 이하가 아닙니다."
        echo "       소유자를 root로 설정하고, 권한을 640 이하로 설정해야 합니다."
    fi
else
    echo "  [취약] /etc/at.deny 파일이 존재하지 않습니다. 파일을 생성해야 합니다."
fi
