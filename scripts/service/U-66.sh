#!/bin/bash

echo "U-66: SNMP 서비스 활성화 여부 점검"

# SNMP 서비스가 활성화 되어 있는지 확인
snmp_status=$(systemctl is-active snmpd)

if [ "$snmp_status" == "active" ]; then
    echo "  [취약] SNMP 서비스가 활성화 되어 있습니다. SNMP 서비스는 보안상 취약할 수 있습니다."
else
    echo "  [양호] SNMP 서비스가 비활성화 되어 있습니다."
fi
