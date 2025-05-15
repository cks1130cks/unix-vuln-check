#!/bin/bash

echo "U-72: 정책에 따른 시스템 로깅 설정 점검"

# 정책상 요구되는 로깅 설정 패턴
declare -a required_patterns=(
    "*.info"
    "authpriv.*"
    "mail.*"
    "cron.*"
    "*.alert"
    "*.emerg"
)

# 점검 대상 로그 설정 파일
declare -a config_files=(
    "/etc/syslog.conf"
    "/etc/rsyslog.conf"
)

log_config_found="no"

for conf_file in "${config_files[@]}"; do
    if [ -f "$conf_file" ]; then
        echo "  로그 설정 파일 확인: $conf_file"
        found_count=0

        for pattern in "${required_patterns[@]}"; do
            if grep -vE '^\s*#' "$conf_file" | grep -q "$pattern"; then
                echo "    [양호] '$pattern' 설정이 존재합니다."
                ((found_count++))
            else
                echo "    [취약] '$pattern' 설정이 누락되었습니다."
            fi
        done

        if [ $found_count -eq ${#required_patterns[@]} ]; then
            echo "  [양호] 로그 정책이 모두 적용되어 있습니다."
        else
            echo "  [취약] 로그 정책이 일부 누락되어 있습니다."
        fi

        log_config_found="yes"
        break
    fi
done

if [ "$log_config_found" = "no" ]; then
    echo "  [취약] 로그 설정 파일이 존재하지 않습니다. (/etc/syslog.conf, /etc/rsyslog.conf)"
fi
