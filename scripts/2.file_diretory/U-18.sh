#!/bin/bash

echo "U-18: 접속 IP 및 포트 제한 설정 여부 점검"

echo "  점검 파일 및 설정:"
echo "    - /etc/hosts.allow (접속 허용 IP 설정 확인)"
echo "    - /etc/hosts.deny (기본 차단 설정 확인)"
echo "    - iptables INPUT 체인 기본 정책 및 규칙 확인"

echo ""
echo "[1] TCP Wrappers 설정 확인"

ALLOW_FILE="/etc/hosts.allow"
DENY_FILE="/etc/hosts.deny"

ALLOW_OK=false
DENY_OK=false

if [ -f "$ALLOW_FILE" ] && grep -vE '^#|^$' "$ALLOW_FILE" | grep -q '[0-9]\{1,3\}\.'; then
    echo "  - /etc/hosts.allow에 특정 IP가 설정되어 있음"
    ALLOW_OK=true
else
    echo "  - /etc/hosts.allow에 특정 IP 설정 없음"
fi

if [ -f "$DENY_FILE" ] && grep -vE '^#|^$' "$DENY_FILE" | grep -q 'ALL: ALL'; then
    echo "  - /etc/hosts.deny에 ALL: ALL 설정되어 있음"
    DENY_OK=true
else
    echo "  - /etc/hosts.deny에 기본 차단 설정 없음"
fi

echo ""
echo "[2] iptables 설정 확인"

IPTABLES_POLICY=$(iptables -L INPUT -n | grep 'Chain INPUT' | awk '{print $4}')
ACCEPT_ALL=$(iptables -L INPUT -n | grep 'ACCEPT' | grep -v '127.0.0.1' | grep -c '0\.0\.0\.0/0')

if [ "$IPTABLES_POLICY" = "DROP" ] && [ "$ACCEPT_ALL" -eq 0 ]; then
    echo "  - iptables 기본 정책이 DROP이며, 전체 허용 규칙이 없음"
    IPTABLES_OK=true
else
    echo "  - iptables에 전체 허용 규칙 존재 또는 기본 정책이 DROP 아님"
    IPTABLES_OK=false
fi


if $ALLOW_OK || $DENY_OK || $IPTABLES_OK; then
    echo "  [양호] 접속을 허용할 특정 IP 또는 포트 제한이 설정되어 있습니다."
else
    echo "  [취약] 접속 제한 없이 IP 접근이 허용되고 있습니다."
fi
