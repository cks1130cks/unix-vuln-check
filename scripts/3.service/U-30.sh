#!/bin/bash

echo "U-30: Sendmail 버전 확인"
echo "  점검 대상: 시스템에 설치된 Sendmail 버전 확인"
echo "  권장 버전: 8.15.2 이상"

if command -v sendmail > /dev/null 2>&1; then
    VERSION=$(sendmail -d0.1 -bt < /dev/null 2>/dev/null | grep "Version" | awk '{print $2}')
    
    if [ -z "$VERSION" ]; then
        echo "  [취약] Sendmail 버전 정보를 확인할 수 없습니다."
    else
        echo "  현재 Sendmail 버전: $VERSION"

        # 버전 비교 (간단히 sort -V 활용)
        if [[ $(echo -e "$VERSION\n8.15.2" | sort -V | head -n1) == "$VERSION" && "$VERSION" != "8.15.2" ]]; then
            echo "  [취약] 구버전 Sendmail 사용 중입니다. 보안 패치를 권장합니다."
        else
            echo "  [양호] 권장 버전 이상입니다."
        fi
    fi
else
    echo "  [양호] Sendmail이 설치되어 있지 않습니다."
fi
