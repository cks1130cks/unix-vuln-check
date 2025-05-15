echo "U-58: 홈 디렉토리 존재 여부"
# /etc/passwd에서 홈 디렉터리 경로 추출
while IFS=: read -r user pass uid gid full home shell; do
    # 홈 디렉터리가 존재하지 않으면 취약한 디렉터리 출력
    if [ ! -d "$home" ]; then
        echo "  [취약]: 홈 디렉터리 '$home'가 존재하지 않음 - 사용자: $user"
    fi
done < /etc/passwd
