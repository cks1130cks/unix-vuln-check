#!/bin/bash
echo "[U-26] session timeout 설정"
grep -q "TMOUT=" /etc/profile
if [ $? -eq 0 ]; then
    echo "결과: 양호 (TMOUT 설정 있음)"
else
    echo "결과: 취약 (TMOUT 설정 없음)"
fi
