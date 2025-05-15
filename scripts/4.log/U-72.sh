#!/bin/bash

echo "U-72: 내부 정책에 따른 시스템 로깅 설정 적용 여부 점검"

# 시스템 로깅 설정 파일과 로그 디렉터리 경로
log_config_file="/etc/rsyslog.conf"
log_dir="/var/log"

echo "  점검 대상 로깅 설정 파일: $log_config_file"
echo "  점검 대상 로그 디렉터리: $log_dir"

# 1. 로깅 설정 파일 존재 여부 확인
if [ -f "$log_config_file" ]; then
    echo "  ▷ 로깅 설정 파일이 존재합니다."

    # 2. 주요 시스템 로그 파일 존재 여부 확인
    auth_log="$log_dir/auth.log"
    syslog_log="$log_dir/syslog"
    messages_log="$log_dir/messages"

    echo "  ▷ 주요 로그 파일 점검:"
    for log_file in "$auth_log" "$syslog_log" "$messages_log"; do
        if [ -f "$log_file" ]; then
            echo "    - $log_file 파일이 존재합니다."
        else
            echo "    - $log_file 파일이 존재하지 않습니다."
        fi
    done

    # 3. 주요 로그 파일 전부 존재하는지 체크
    if [ -f "$auth_log" ] && [ -f "$syslog_log" ] && [ -f "$messages_log" ]; then
        echo "  [양호] 주요 시스템 로그 파일이 모두 존재하며 로깅이 활성화되어 있습니다."
    else
        echo "  [취약] 일부 주요 시스템 로그 파일이 없거나 로깅 활성화가 제대로 되어 있지 않습니다."
    fi

    # 4. 로그 회전 정책 파일 존재 여부 확인
    logrotate_file="/etc/logrotate.conf"
    echo "  ▷ 로그 회전 정책 파일 점검: $logrotate_file"
    if [ -f "$logrotate_file" ]; then
        echo "  [양호] 로그 회전 정책 파일이 존재합니다."
    else
        echo "  [취약] 로그 회전 정책 파일이 존재하지 않습니다."
    fi

else
    echo "  [취약] 로깅 설정 파일($log_config_file)이 존재하지 않거나 로깅 설정이 미수립되어 있습니다."
fi
