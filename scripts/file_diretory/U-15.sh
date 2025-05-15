echo "U-15: 불필요한 world writable 파일 존재 여부 점검"

output=$(find / -xdev -type f -perm -002 ! -perm -1000 2>/dev/null)

if [ -z "$output" ]; then
    echo "  [양호] 불필요한 world writable 파일이 존재하지 않습니다."
else
    echo "  [취약] 다음과 같은 불필요한 world writable 파일이 존재합니다:"
    echo "$output"
fi
