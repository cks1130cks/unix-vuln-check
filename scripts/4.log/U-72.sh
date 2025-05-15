#!/bin/bash

echo "U-72: 내부 정책에 따른 시스템 로깅 설정 적용 여부 점검"

# 시스템 로깅 설정 파일 확인 (예: rsyslog 또는 syslog 설정)
log_config_file="/etc/rsyslog.conf"
log_dir="/var/log"

# 로깅 정책이 설정되어 있는지 확인 (rsyslog 설정 확인)
if [ -f "$log_config_file" ]; then
    echo "  로깅 설정 파일 ($log_config_file) 존재"

    # 주요 로그 파일 존재 여부 확인 (예: /var/log/auth.log, /var/log/syslog, /var/log/messages)
    if [ -f "$log_dir/auth.log" ] && [ -f "$log_dir/syslog" ] && [ -f "$log_dir/messages" ]; then
        echo "  [양호] 주요 시스템 로그 파일이 존재하며 로깅이 활성화 되어 있습니다."
    else
        echo "  [취약] 주요 시스템 로그 파일이 존재하지 않거나 로깅이 활성화 되어 있지 않습니다."
    fi

    # 로그 정책 문서 또는 관련 지침이 존재하는지 확인 (파일이나 디렉토리 점검)
    if [ -f "/etc/logrotate.conf" ]; then
        echo "  로그 회전 정책 파일 존재"
    else
        echo "  [취약] 로그 회전 정책 파일이 존재하지 않습니다."
    fi
else
    echo "  [취약] 로깅 설정 파일이 존재하지 않거나 로깅 설정이 미수립되었습니다."
fi
