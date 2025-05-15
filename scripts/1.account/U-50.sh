echo "U-50: 관리자 그룹에 최소한의 사용자 등록"
root_users=$(grep "^root" /etc/group | cut -d: -f4)
echo "  root 그룹 사용자: $root_users"
if [ "$root_users" = "root" ] || [ -z "$root_users" ]; then
    echo "  [양호]"
else
    echo "  [취약]"
fi
