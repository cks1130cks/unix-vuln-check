echo "U-57: 홈 디렉토리 소유자 및 권한 설정"
result="양호"
for dir in /home/*; do
    [ -d "$dir" ] || continue
    user=$(basename "$dir")
    owner=$(stat -c %U "$dir")
    perms=$(stat -c %a "$dir")
    if [ "$owner" != "$user" ] || [ "$perms" -gt 750 ]; then
        echo "$dir → 소유자:$owner, 권한:$perms (문제 있음)"
        result="취약"
    fi
done
echo "결과: $result"
echo
