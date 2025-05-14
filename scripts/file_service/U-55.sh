echo "===== U-55: hosts.lpd 파일 소유자 및 권한 설정 ====="
file="/etc/hosts.lpd"
if [ -e "$file" ]; then
    owner=$(stat -c %U "$file")
    perms=$(stat -c %a "$file")
    echo "소유자: $owner, 권한: $perms"
    if [ "$owner" = "root" ] && [ "$perms" -le 640 ]; then
        echo "결과: 양호"
    else
        echo "결과: 취약"
    fi
else
    echo "파일 없음 → 결과: 양호"
fi
echo
