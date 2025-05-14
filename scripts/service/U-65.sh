#!/bin/bash

echo "U-65: 관리자(root)만 at.allow 파일과 at.deny 파일을 제어할 수 있는지 점검"

at_allow_file="/etc/at.allow"
at_deny_file="/etc/at.deny"

secure=1

# 1. at.allow 파일 점검
if [ -f "$at_allow_file" ]; then
    file_owner=$(stat -c %U "$at_allow_file")
    file_permissions=$(stat -c %a "$at_allow_file")

    if [ "$file_owner" == "root" ] && [ "$file_permissions" -le 640 ]; then
        echo "  [양호] $at_allow_file: 소유자 root, 권한 640 이하"
    else
        echo "  [취약] $at_allow_file: 소유자 또는 권한 설정이 적절하지 않음"
        secure=0
    fi
else
    echo "  [취약] $at_allow_file 파일이 존재하지 않음"
    secure=0
fi

# 2. at.deny 파일 점검
if [ -f "$at_deny_file" ]; then
    file_owner=$(stat -c %U "$at_deny_file")
    file_permissions=$(stat -c %a "$at_deny_file")

    if [ "$file_owner" == "root" ] && [ "$file_permissions" -le 640 ]; then
        echo "  [양호] $at_deny_file: 소유자 root, 권한 640 이하"
    else
        echo "  [취약] $at_deny_file: 소유자 또는 권한 설정이 적절하지 않음"
        secure=0
    fi
else
    echo "  [취약] $at_deny_file 파일이 존재하지 않음"
    secure=0
fi

# 3. 일반 사용자의 at 명령어 사용 가능 여부 확인
# 예시 사용자 지정 (root가 아닌 사용자로 확인)
test_user="nobody"

if su -s /bin/bash -c "at -l" "$test_user" 2>/dev/null | grep -q "no jobs"; then
    echo "  [취약] 일반 사용자($test_user)가 at 명령어를 사용할 수 있습니다."
    secure=0
else
    echo "  [양호] 일반 사용자($test_user)는 at 명령어를 사용할 수 없습니다."
fi

# 최종 결과
if [ "$secure" -eq 1 ]; then
    echo "  [최종 결과: 양호] at 명령 제한 및 관련 파일 설정이 적절합니다."
else
    echo "  [최종 결과: 취약] at 명령 제한 또는 파일 설정에 보안 취약점이 존재합니다."
fi
