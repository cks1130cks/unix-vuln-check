#!/bin/bash

echo "U-68: 서버 및 서비스에 로그온 시 불필요한 정보 차단 설정 및 불법적인 사용에 대한 경고 메시지 출력 여부 점검"

# /etc/motd 파일이 존재하는지 확인 (일반적인 로그온 메시지 파일)
if [ -f "/etc/motd" ]; then
    echo "  [양호] /etc/motd 파일에 로그인 메시지가 설정되어 있습니다."
else
    echo "  [취약] /etc/motd 파일에 로그인 메시지가 설정되어 있지 않습니다."
fi

# Telnet 서비스의 로그인 메시지 확인
if [ -f "/etc/issue.net" ]; then
    echo "  [양호] /etc/issue.net 파일에 Telnet 로그인 메시지가 설정되어 있습니다."
else
    echo "  [취약] /etc/issue.net 파일에 Telnet 로그인 메시지가 설정되어 있지 않습니다."
fi

# FTP 서비스의 로그인 메시지 확인
if [ -f "/etc/vsftpd/vsftpd.conf" ] && grep -q "ftpd_banner" "/etc/vsftpd/vsftpd.conf"; then
    echo "  [양호] /etc/vsftpd/vsftpd.conf 파일에 FTP 로그인 메시지가 설정되어 있습니다."
else
    echo "  [취약] /etc/vsftpd/vsftpd.conf 파일에 FTP 로그인 메시지가 설정되어 있지 않습니다."
fi

# SMTP 서비스의 로그인 메시지 확인
if [ -f "/etc/mail/sendmail.cf" ] && grep -q "O Smtp GreetingMessage" "/etc/mail/sendmail.cf"; then
    echo "  [양호] /etc/mail/sendmail.cf 파일에 SMTP 로그인 메시지가 설정되어 있습니다."
else
    echo "  [취약] /etc/mail/sendmail.cf 파일에 SMTP 로그인 메시지가 설정되어 있지 않습니다."
fi

# DNS 서비스의 로그인 메시지 확인
if [ -f "/etc/named.conf" ]; then
    echo "  [양호] /etc/named.conf 파일에 DNS 로그인 메시지가 설정되어 있습니다."
elif [ -f "/etc/bind/named.conf" ]; then
    echo "  [양호] /etc/bind/named.conf 파일에 DNS 로그인 메시지가 설정되어 있습니다."
else
    echo "  [취약] DNS 서비스에 로그인 메시지가 설정되어 있지 않습니다."
fi
