#!/bin/bash

echo "U-65: 관리자(root)만 at.allow 파일과 at.deny 파일을 제어할 수 있는지 점검"

# at.allow 및 at.deny 파일 경로
at_allow="/etc/at.allow"
at_deny="/etc/at.deny"

at_command_protected=true

# at.allow가 존재할 경우 root만 등록되어 있어야 함
if [ -f "$at_allow" ]; then
    users=$(grep -v '^\s*$' "$at_allow" | sort | uniq)
    if [[ "$users" == "root" ]]; then
        echo "  [양호] at.allow 파일에 root만 등록되어 있습니다."
    else
        echo "  [취약] at.allow 파일에 root 외 사용자가 포함되어 있습니다."
        at_command_protected=false
    fi
else
    echo "  [취약] at.allow 파일이 존재하지 않아 일반 사용자도 at 명령어 사용이 가능합니다."
    at_command_protected=false
fi

# at.allow 및 at.deny 파일 권한/소유자 점검 함수
check_file() {
    file=$1
    if [ -f "$file" ]; then
        owner=$(stat -c %U "$file")
        perms=$(stat -c %a "$file")
        if [ "$owner" == "root" ] && [ "$perms" -le 640 ]; then
            echo "  [양호] $file 파일의 소유자가 root이고, 권한이 640 이하입니다."
        else
            echo "  [취약] $file 파일의 소유자가 root가 아니거나 권한이 640 초과입니다."
            at_command_protected=false
        fi
    else
        echo "  [정보] $file 파일이 존재하지 않습니다."
    fi
}

# at.allow, at.deny 각각 점검
check_file "$at_allow"
check_file "$at_deny"

# 최종 평가
if [ "$at_command_protected" = true ]; then
    echo "  [최종 판정: 양호] at 명령어가 일반 사용자에게 금지되어 있고, 관련 파일의 권한 설정도 적절합니다."
else
    echo "  [최종 판정: 취약] at 명령어를 일반 사용자가 사용할 수 있거나, 관련 파일의 권한 설정이 미흡합니다."
fi
