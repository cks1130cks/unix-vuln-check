echo "U-53: 시스템 계정에 로그인 shell 부여 금지"
issues=$(awk -F: '$3<1000 && $7 !~ /(nologin|false)/ {print $1}' /etc/passwd)
if [ -n "$issues" ]; then
    echo "  [취약] 로그인 가능한 시스템 계정: $issues"
else
    echo "  [양호]"
fi
