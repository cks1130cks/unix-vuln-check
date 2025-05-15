#!/bin/bash

echo "U-67: SNMP Community String 복잡성 설정 여부 점검"

snmp_config_file="/etc/snmp/snmpd.conf"

if [ -f "$snmp_config_file" ]; then
    echo "  SNMP 설정 파일 위치: $snmp_config_file"
    
    # 설정된 community string 추출 (주석 제외하고 com2sec 줄에서 4번째 필드)
    community_list=$(grep -vE '^\s*#' "$snmp_config_file" | grep -E '^com2sec' | awk '{print $4}')
    
    if [ -z "$community_list" ]; then
        echo "  [정보] SNMP Community String 설정이 발견되지 않았습니다."
    else
        echo "  현재 설정된 SNMP Community String 목록:"
        echo "$community_list" | sed 's/^/    - /'
        
        # 기본값(public 또는 private)이 포함되어 있는지 확인
        if echo "$community_list" | grep -qwE 'public|private'; then
            echo "  [취약] 기본값인 'public' 또는 'private'가 포함되어 있습니다."
            echo "    - 보안상 매우 위험하니 반드시 변경해야 합니다."
        else
            echo "  [양호] 기본값을 사용하지 않고 복잡한 문자열로 설정되어 있습니다."
        fi
    fi
else
    echo "  [취약] SNMP 설정 파일($snmp_config_file)이 존재하지 않습니다."
fi
