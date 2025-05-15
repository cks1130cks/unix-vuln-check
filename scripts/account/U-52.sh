echo "===== U-52: 동일한 UID 금지 ====="

# U-52: 동일한 UID 0 존재 여부 점검

# UID 0을 가진 계정을 확인합니다.
uids=$(awk -F: '$3 == 0 {print $1}' /etc/passwd)

# UID 0을 가진 계정 중 root 외에 다른 계정이 존재하는지 확인
if echo "$uids" | grep -v -w "root" > /dev/null; then
    echo "U-52 점검 결과: 취약"
    echo "취약한 계정 목록:"
    echo "$uids" | grep -v -w "root"
else
    echo "U-52 점검 결과: 양호"
fi
