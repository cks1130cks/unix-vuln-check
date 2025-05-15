#!/bin/bash
echo "U-43: 로그의 정기적 검토 및 보고 여부 점검"

LOG_FILE="/var/log/messages"

echo "  점검 대상 로그 파일: $LOG_FILE"

if [ -f "$LOG_FILE" ]; then
    echo "  ▷ 로그 파일이 존재합니다."
    # 최근 1일 (1440분) 이내에 로그 파일이 수정되었는지 확인
    if find "$LOG_FILE" -mmin -1440 | grep -q .; then
        echo "  [양호] 로그 파일이 최근 1일 이내에 수정되어 정기적 로그 기록 및 검토가 이루어지고 있음을 의미합니다."
    else
        echo "  [취약] 로그 파일이 최근 1일 이내에 수정되지 않았습니다. 로그 검토 및 기록이 정상적으로 수행되고 있는지 확인이 필요합니다."
    fi
else
    echo "  [취약] 로그 파일이 존재하지 않습니다. ($LOG_FILE)"
fi
