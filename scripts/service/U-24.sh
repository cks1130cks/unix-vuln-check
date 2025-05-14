#!/bin/bash
echo "[U-24] 시스템 계정 쉘 제한"
awk -F: '($3 < 1000 && $1 != "root" && $7 != "/sbin/nologin" && $7 != "/bin/false") {print $1, $7}' /etc/passwd
