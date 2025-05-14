#!/bin/bash
echo "[U-43] 로그의 정기적 검토 및 보고 여부"
LOG_FILE="/var/log/messages"
if [ -f "$LOG_FILE" ]; then
    echo "로그 파일 존재 확인됨: $LOG_FILE"
    if find "$LOG_FILE" -mmin -1440 | grep -q .; then
        echo "결과: 양호 (로그 파일이 최근 1일 이내에 수정됨)"
    else
        echo "결과: 취약 (로그 검토가 오래됨)"
    fi
else
    echo "결과: 취약 (로그 파일 없음)"
fi
