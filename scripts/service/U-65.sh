#!/bin/bash

echo "U-65: at 명령어 일반사용자 금지 및 at 관련 파일 보안설정 점검"

at_allow="/etc/at.allow"
at_deny="/etc/at.deny"

# at.allow 파일이 존재하면 이 파일만으로 판단
if [ -f "$at_allow" ]; then
    owner=$(stat -c %U "$at_allow")
    perm=$(stat -c %a "$at_allow")
    
    if [ "$owner" == "root" ] && [ "$perm" -le 640 ]; then
        # 파일 내용 확인
        non_root_users=$(grep -v '^#' "$at_allow" | grep -v '^root$')

        if [ -z "$non_root_users" ]; then
            echo "  [양호] at.allow 파일의 소유자/권한이 적절하고 root만 사용 가능하도록 설정되어 있습니다."
        else
            echo "  [취약] at.allow 파일에 root 외 일반 사용자가 포함되어 있습니다: $non_root_users"
        fi
    else
        echo "  [취약] at.allow 파일의 소유자가 root가 아니거나, 권한이 640 초과입니다."
    fi

# at.allow 파일이 없고, at.deny만 존재하는 경우 → 취약
elif [ -f "$at_deny" ]; then
    echo "  [취약] at.allow 파일이 없어 일반 사용자가 at 명령을 사용할 수 있습니다."
else
    echo "  [취약] at.allow 및 at.deny 파일이 모두 없어, 모든 사용자가 at 명령을 사용할 수 있습니다."
fi
