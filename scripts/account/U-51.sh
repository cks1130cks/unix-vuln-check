echo "U-51: 계정이 존재하지 않는 GID 금지"
result="양호"
for gid in $(cut -d: -f4 /etc/passwd); do
    if ! getent group "$gid" > /dev/null; then
        echo "  GID $gid 가 /etc/group에 존재하지 않음"
        result="취약"
    fi
done
echo "  [$result]"
