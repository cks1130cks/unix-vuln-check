#!/bin/bash

echo "U-67: SNMP Community String 복잡성 설정 여부 점검"

# SNMP 설정 파일 경로
snmp_config_file="/etc/snmp/snmpd.conf"

# SNMP 설정 파일에서 community string 확인
if [ -f "$snmp_config_file" ]; then
    if grep -qE 'com2sec\s+\S+\s+\S+\s+(public|private)' "$snmp_config_file"; then
        echo "  [취약] SNMP Community String이 기본값인 'public' 또는 'private'로 설정되어 있습니다."
    else
        echo "  [양호] SNMP Community String이 안전한 이름으로 설정되어 있습니다."
    fi
else
    echo "  [취약] SNMP 설정 파일($snmp_config_file)이 존재하지 않습니다. SNMP 설정 파일을 확인해야 합니다."
fi
