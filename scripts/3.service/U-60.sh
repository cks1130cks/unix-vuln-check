#!/bin/bash

echo "U-60: 원격 접속 시 SSH 프로토콜 점검"

# 1. SSH 서비스 확인
ssh_status=$(systemctl is-active sshd)
if [ "$ssh_status" == "active" ]; then
    echo "  [양호] SSH 서비스가 실행 중입니다."
else
    echo "  [취약] SSH 서비스가 실행 중이 아닙니다. SSH 서비스를 활성화해야 합니다."
fi

# 2. Telnet 서비스 확인
telnet_status=$(systemctl is-active telnet.socket)
if [ "$telnet_status" == "active" ]; then
    echo "  [취약] Telnet 서비스가 실행 중입니다. 보안상 취약하므로 서비스를 비활성화해야 합니다."
else
    echo "  [양호] Telnet 서비스가 실행 중이지 않습니다."
fi

# 3. FTP 서비스 확인
ftp_status=$(systemctl is-active vsftpd)
if [ "$ftp_status" == "active" ]; then
    echo "  [취약] FTP 서비스가 실행 중입니다. 보안상 취약하므로 서비스를 비활성화해야 합니다."
else
    echo "  [양호] FTP 서비스가 실행 중이지 않습니다."
fi
