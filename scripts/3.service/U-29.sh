#!/bin/bash

echo "U-29: tftp, talk 서비스 비활성화 점검"
echo "  점검 파일:"
echo "    - /etc/xinetd.d/tftp"
echo "    - /etc/xinetd.d/talk"

# tftp 또는 talk 서비스 관련 설정 파일 존재 여부 확인
found_files=()
[ -f /etc/xinetd.d/tftp ] && found_files+=("/etc/xinetd.d/tftp")
[ -f /etc/xinetd.d/talk ] && found_files+=("/etc/xinetd.d/talk")

if [ ${#found_files[@]} -gt 0 ]; then
    echo "  [취약] 다음 서비스 파일이 존재합니다:"
    for file in "${found_files[@]}"; do
        echo "    - $file"
    done
else
    echo "  [양호] tftp 및 talk 서비스 관련 파일이 존재하지 않습니다."
fi
