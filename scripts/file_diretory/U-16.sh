 "[U-16] /dev에 존재하지 않는 일반 파일 점검"

# /dev 하위의 일반 파일 검색
output=$(find /dev -type f 2>/dev/null)

if [ -z "$output" ]; then
    echo "결과: 양호 - /dev 디렉토리에 일반 파일이 존재하지 않습니다."
else
    echo "결과: 취약 - /dev 디렉토리에 일반 파일이 존재합니다."
fi
