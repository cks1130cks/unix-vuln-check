#!/bin/bash

echo "U-56: UMASK 설정 점검"

# 점검 대상 파일
FILE="/etc/profile"

echo "  점검 파일: $FILE"

# /etc/profile 파일에서 UMASK 설정된 줄 추출 (주석 제외, 첫 줄)
umask_line=$(grep -i 'umask' "$FILE" | grep -v '^\s*#' | head -n 1)

# 현재 쉘 환경의 umask 값 확인
current_umask=$(umask)

if [[ -z "$umask_line" ]]; then
    echo "  현재 UMASK 설정: $current_umask"
    echo "  [취약] /etc/profile에 UMASK 설정이 없습니다."
else
    # 파일에서 찾은 설정된 umask 값 추출 (숫자 3자리)
    configured_umask=$(echo "$umask_line" | grep -o '[0-7]\{3\}')
    echo "  /etc/profile 내 UMASK 설정 내용: $umask_line"
    echo "  설정된 UMASK 값: $configured_umask"

    if [[ "$configured_umask" == "022" ]]; then
        echo "  [양호] UMASK 값이 022로 설정되어 있습니다."
    else
        echo "  [취약] UMASK 값이 022로 설정되어 있지 않습니다."
        echo "         보안을 위해 UMASK 값을 022로 설정하는 것이 권장됩니다."
    fi
fi
