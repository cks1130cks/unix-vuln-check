#!/bin/bash
echo "U-68 로그온 시 경고 메시지 제공"

# 공통 경고 메시지 예시 (변경 가능)
EXPECTED_MSG="WARNING: Authorized use only. Unauthorized access prohibited."

check_msg_in_file() {
    local file=$1
    if [ -f "$file" ]; then
        grep -qF "$EXPECTED_MSG" "$file"
        if [ $? -eq 0 ]; then
            echo "[양호] $file 에 경고 메시지가 설정되어 있습니다."
        else
            echo "[취약] $file 에 경고 메시지가 없습니다."
        fi
    else
        echo "[정보] $file 파일이 존재하지 않습니다."
    fi
}

# 1. 서버 로그인 배너: /etc/motd
check_msg_in_file "/etc/motd"

# 2. Telnet 배너
# SOLARIS: /etc/default/telnetd
check_msg_in_file "/etc/default/telnetd"
# LINUX: /etc/issue.net
check_msg_in_file "/etc/issue.net"
# HP-UX: /etc/issue (telnet -b 옵션 배너)
check_msg_in_file "/etc/issue"

# 3. FTP 배너
# SOLARIS, LINUX: /etc/default/ftpd, /etc/vsftpd/vsftpd.conf
check_msg_in_file "/etc/default/ftpd"
check_msg_in_file "/etc/vsftpd/vsftpd.conf"
# HP-UX: /etc/ftpd/ftp_banner (ftpd 배너 파일)
check_msg_in_file "/etc/ftpd/ftp_banner"

# 4. SMTP 배너: /etc/mail/sendmail.cf
check_msg_in_file "/etc/mail/sendmail.cf"

# 5. DNS 배너: /etc/named.conf
check_msg_in_file "/etc/named.conf"

