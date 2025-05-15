#!/bin/bash
echo "U-68 로그온 시 경고 메시지 제공 점검 시작"

# 공통 경고 메시지 예시 (실제 환경에 맞게 변경 가능)
EXPECTED_MSG="WARNING: Authorized use only. Unauthorized access prohibited."

# 함수: 파일 내 경고 메시지 포함 여부 확인
check_msg_in_file() {
    local file=$1
    local description=$2

    if [ -f "$file" ]; then
        # 파일 존재 시, 경고 메시지 포함 여부 검사
        if grep -qF "$EXPECTED_MSG" "$file"; then
            echo "[양호] $description ($file)에 경고 메시지가 설정되어 있습니다."
        else
            echo "[취약] $description ($file)에 경고 메시지가 없습니다."
        fi
    else
        echo "[정보] $description ($file) 파일이 존재하지 않습니다."
    fi
}

# 1. 서버 로그인 배너 설정: /etc/motd
check_msg_in_file "/etc/motd" "서버 로그인 배너 (/etc/motd)"

# 2. Telnet 배너 설정
# Solaris: /etc/default/telnetd
check_msg_in_file "/etc/default/telnetd" "Telnet 배너 (Solaris /etc/default/telnetd)"
# Linux: /etc/issue.net
check_msg_in_file "/etc/issue.net" "Telnet 배너 (Linux /etc/issue.net)"
# HP-UX: /etc/issue (telnet -b 옵션 배너)
check_msg_in_file "/etc/issue" "Telnet 배너 (HP-UX /etc/issue)"

# 3. FTP 배너 설정
# Solaris, Linux: /etc/default/ftpd, /etc/vsftpd/vsftpd.conf
check_msg_in_file "/etc/default/ftpd" "FTP 배너 (Solaris, Linux /etc/default/ftpd)"
check_msg_in_file "/etc/vsftpd/vsftpd.conf" "FTP 배너 (Linux /etc/vsftpd/vsftpd.conf)"
# HP-UX: /etc/ftpd/ftp_banner
check_msg_in_file "/etc/ftpd/ftp_banner" "FTP 배너 (HP-UX /etc/ftpd/ftp_banner)"

# 4. SMTP 배너 설정: /etc/mail/sendmail.cf
check_msg_in_file "/etc/mail/sendmail.cf" "SMTP 배너 (/etc/mail/sendmail.cf)"

# 5. DNS 배너 설정: /etc/named.conf
check_msg_in_file "/etc/named.conf" "DNS 배너 (/etc/named.conf)"

echo "U-68 로그온 시 경고 메시지 제공 점검 종료"
