#!/bin/bash
echo "U-68: 로그온 시 경고 메시지 제공"

EXPECTED_MSG="WARNING: Authorized use only. Unauthorized access prohibited."

check_msg_in_file() {
    local file=$1
    local description=$2

    if [ -f "$file" ]; then
        if grep -qF "$EXPECTED_MSG" "$file"; then
            echo "  [양호] $description ($file)에 경고 메시지가 설정되어 있습니다."
        else
            echo "  [취약] $description ($file)에 경고 메시지가 없습니다."
        fi
    else
        echo "  [정보] $description ($file) 파일이 존재하지 않습니다."
    fi
}

check_msg_in_file "/etc/motd" "서버 로그인 배너 (/etc/motd)"

check_msg_in_file "/etc/default/telnetd" "Telnet 배너 (Solaris /etc/default/telnetd)"
check_msg_in_file "/etc/issue.net" "Telnet 배너 (Linux /etc/issue.net)"
check_msg_in_file "/etc/issue" "Telnet 배너 (HP-UX /etc/issue)"

check_msg_in_file "/etc/default/ftpd" "FTP 배너 (Solaris, Linux /etc/default/ftpd)"
check_msg_in_file "/etc/vsftpd/vsftpd.conf" "FTP 배너 (Linux /etc/vsftpd/vsftpd.conf)"
check_msg_in_file "/etc/ftpd/ftp_banner" "FTP 배너 (HP-UX /etc/ftpd/ftp_banner)"

check_msg_in_file "/etc/mail/sendmail.cf" "SMTP 배너 (/etc/mail/sendmail.cf)"

check_msg_in_file "/etc/named.conf" "DNS 배너 (/etc/named.conf)"
