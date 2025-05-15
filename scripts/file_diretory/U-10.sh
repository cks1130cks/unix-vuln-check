#!/bin/bash

FILE="/etc/xinetd.conf"

echo "U-20: /etc/xinetd.conf 파일 권한 및 소유자 점검"

# 파일 존재 여부 확인
if [ -f "$FILE" ]; then
    PERM=$(stat -c "%a" "$FILE")
    OWNER=$(stat -c "%U" "$FILE")
    GROUP=$(stat -c "%G" "$FILE")

    echo "   파일 존재 확인: $FILE"
    echo "   현재 권한: $PERM, 소유자: $OWNER, 그룹: $GROUP"

    # 권한 및 소유자 점검
    if [[ "$PERM" -le 600 && "$OWNER" == "root" && "$GROUP" == "root" ]]; then
        echo "  [양호] 권한과 소유자 설정이 적절합니다."
    else
        echo "  [취약] 권한 또는 소유자 설정이 적절하지 않습니다."
        echo "     └ 권장 설정: 소유자 root, 권한 600"
    fi
else
    echo "  [정보] $FILE 파일이 존재하지 않습니다. (xinetd 미사용 시스템일 수 있음)"
fi
