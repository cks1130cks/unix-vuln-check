echo "===== U-53: 시스템 계정에 로그인 shell 부여 금지 ====="
issues=$(awk -F: '$3<1000 && $7 !~ /(nologin|false)/ {print $1}' /etc/passwd)
if [ -n "$issues" ]; then
    echo "로그인 가능한 시스템 계정: $issues"
    echo "결과: 취약"
else
    echo "결과: 양호"
fi
echo
