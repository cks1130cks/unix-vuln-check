#!/bin/bash

echo "U-18: 접속 IP 및 포트 제한 설정 여부 점검"

echo "  점검 파일 및 설정:"
echo "    - /etc/hosts.allow (접속 허용 IP 설정 확인)"
echo "    - /etc/hosts.deny (기본 차단 설정 확인)"
echo "    - iptables INPUT 체인 기본 정책 및 규칙 확인"

echo ""
echo "[1] TCP Wrappers 설정 확인"
/etc/hosts.allow와 /etc/hosts.deny 파일은 시스템 접속 제어의 기본 중 하나로, 신뢰된 IP만 허용하고 나머지는 차단하는 역할을 합니다.

ALLOW_FILE="/etc/hosts.allow"
DENY_FILE="/etc/hosts.deny"

ALLOW_OK=false
DENY_OK=false

if [ -f "$ALLOW_FILE" ]; then
    # 주석과 빈 줄 제외 후 IP 형식 존재 확인
    if grep -vE '^#|^$' "$ALLOW_FILE" | grep -qE '[0-9]{1,3}(\.[0-9]{1,3}){3}'; then
        echo "  - /etc/hosts.allow에 특정 IP 또는 호스트가 허용 설정되어 있음"
        echo "    (특정 IP만 접근을 허용함으로써 보안을 강화)"
        ALLOW_OK=true
    else
        echo "  - /etc/hosts.allow에 유효한 IP 허용 설정이 없음"
        echo "    (접근 제어가 미흡할 수 있음)"
    fi
else
    echo "  - /etc/hosts.allow 파일이 존재하지 않음"
fi

if [ -f "$DENY_FILE" ]; then
    if grep -vE '^#|^$' "$DENY_FILE" | grep -q '^ALL:\s*ALL'; then
        echo "  - /etc/hosts.deny에 기본 차단 설정(ALL: ALL) 존재"
        echo "    (허용되지 않은 모든 접근을 차단하는 기본 보안 정책)"
        DENY_OK=true
    else
        echo "  - /etc/hosts.deny에 기본 차단 설정(ALL: ALL) 없음"
        echo "    (기본 차단 정책 부재로 보안 취약 가능)"
    fi
else
    echo "  - /etc/hosts.deny 파일이 존재하지 않음"
fi

echo ""
echo "[2] iptables 설정 확인"
# iptables 기본 INPUT 체인 정책과 허용 규칙을 점검
IPTABLES_POLICY=$(iptables -L INPUT -n | grep 'Chain INPUT' | awk '{print $4}')
ACCEPT_ALL=$(iptables -L INPUT -n | grep 'ACCEPT' | grep -v '127.0.0.1' | grep -c '0\.0\.0\.0/0')

if [ "$IPTABLES_POLICY" = "DROP" ]; then
    if [ "$ACCEPT_ALL" -eq 0 ]; then
        echo "  - iptables 기본 정책이 DROP이며, 모든 IP를 허용하는 규칙이 없음"
        echo "    (허용된 IP만 접속 가능하도록 강력히 제한됨)"
        IPTABLES_OK=true
    else
        echo "  - iptables 기본 정책은 DROP이나, 전체 IP 허용 규칙이 존재함"
        echo "    (일부 포트나 IP에 대해 과도하게 열려 있을 수 있음)"
        IPTABLES_OK=false
    fi
else
    echo "  - iptables 기본 정책이 DROP이 아님 (현재: $IPTABLES_POLICY)"
    echo "    (기본 정책이 ACCEPT 등으로 설정된 경우, 모든 접속이 허용될 수 있음)"
    IPTABLES_OK=false
fi

echo ""
# 최종 종합 판단
if $ALLOW_OK || $DENY_OK || $IPTABLES_OK; then
    echo "  [양호] 접속 제한 정책이 적절히 설정되어 있습니다."
    echo "    - 신뢰된 IP만 접근 가능하도록 제한하는 것은 시스템 보안의 기본입니다."
else
    echo "  [취약] 접속 제한이 미흡하여 IP 기반 접근 제어가 제대로 이루어지지 않고 있습니다."
    echo "    - 즉시 /etc/hosts.allow, /etc/hosts.deny 설정 및 iptables 규칙을 점검하고 개선하세요."
fi
