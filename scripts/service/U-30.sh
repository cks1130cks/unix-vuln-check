#!/bin/bash
echo "U-30: Sendmail 버전 확인"
if command -v sendmail > /dev/null; then
    VERSION=$(sendmail -d0.1 -bt < /dev/null 2>/dev/null | grep "Version" | awk '{print $2}')
    echo "Sendmail version: $VERSION"
    if [[ "$VERSION" < "8.15.2" ]]; then
        echo "  [취약] (구버전 Sendmail 사용 중)"
    else
        echo "  [양호]"
    fi
else
    echo "  [양호] Sendmail이 설치되어 있지 않음"
fi
