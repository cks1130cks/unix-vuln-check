#!/bin/bash

echo "U-68: 서버 및 서비스에 로그온 시 불필요한 정보 차단 설정 및 불법적인 사용에 대한 경고 메시지 출력 여부 점검"

# 1. /etc/motd 파일 확인 (일반 로그인 메시지)
if [ -f "/etc/motd" ]; then
    echo "  ▷ /etc/motd 파일 존재: 있음"
    motd_content=$(head -20 /etc/motd)
    echo "    내용 일부:"
    echo "    --------------------"
    echo "$motd_content" | sed 's/^/    /'
    echo "    --------------------"
    echo "  [양호] /etc/motd 파일에 로그인 메시지가 설정되어 있습니다."
else
    echo "  [취약] /etc/motd 파일에 로그인 메시지가 설정되어 있지 않습니다."
fi

# 2. Telnet 로그인 메시지 (/etc/issue.net) 확인
if [ -f "/etc/issue.net" ]; then
    echo "  ▷ /etc/issue.net 파일 존재: 있음"
    issue_net_content=$(head -20 /etc/issue.net)
    echo "    내용 일부:"
    echo "    --------------------"
    echo "$issue_net_content" | sed 's/^/    /'
    echo "    --------------------"
    echo "  [양호] /etc/issue.net 파일에 Telnet 로그인 메시지가 설정되어 있습니다."
else
    echo "  [취약] /etc/issue.net 파일에 Telnet 로그인 메시지가 설정되어 있지 않습니다."
fi

# 3. FTP 로그인 메시지 (/etc/vsftpd/vsftpd.conf) 확인
ftp_conf="/etc/vsftpd/vsftpd.conf"
if [ -f "$ftp_conf" ]; then
    echo "  ▷ FTP 설정 파일 존재: $ftp_conf"
    if grep -q "^ftpd_banner" "$ftp_conf"; then
        ftp_banner=$(grep "^ftpd_banner" "$ftp_conf")
        echo "    설정 내용: $ftp_banner"
        echo "  [양호] FTP 로그인 메시지가 설정되어 있습니다."
    else
        echo "  [취약] FTP 로그인 메시지가 설정되어 있지 않습니다."
    fi
else
    echo "  [취약] FTP 설정 파일($ftp_conf)이 존재하지 않습니다."
fi

# 4. SMTP 로그인 메시지 (/etc/mail/sendmail.cf) 확인
smtp_conf="/etc/mail/sendmail.cf"
if [ -f "$smtp_conf" ]; then
    echo "  ▷ SMTP 설정 파일 존재: $smtp_conf"
    if grep -q "^O SmtpGreetingMessage" "$smtp_conf"; then
        smtp_greeting=$(grep "^O SmtpGreetingMessage" "$smtp_conf")
        echo "    설정 내용: $smtp_greeting"
        echo "  [양호] SMTP 로그인 메시지가 설정되어 있습니다."
    else
        echo "  [취약] SMTP 로그인 메시지가 설정되어 있지 않습니다."
    fi
else
    echo "  [취약] SMTP 설정 파일($smtp_conf)이 존재하지 않습니다."
fi

# 5. DNS 서비스 로그인 메시지 확인 (named.conf)
dns_conf_paths=("/etc/named.conf" "/etc/bind/named.conf")
dns_conf_found=0
for dns_conf in "${dns_conf_paths[@]}"; do
    if [ -f "$dns_conf" ]; then
        dns_conf_found=1
        echo "  ▷ DNS 설정 파일 존재: $dns_conf"
        echo "  [양호] DNS 서비스에 로그인 메시지가 설정되어 있을 가능성이 있습니다."
        break
    fi
done
if [ "$dns_conf_found" -eq 0 ]; then
    echo "  [취약] DNS 서비스에 로그인 메시지가 설정되어 있지 않습니다."
fi
