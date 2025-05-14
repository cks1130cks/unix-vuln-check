echo "U-59: 숨겨진 파일 및 디렉토리 점검"
#!/bin/bash

# 시스템에서 숨겨진 파일 및 디렉토리 검색
hidden_files=$(find / -name ".*" 2>/dev/null)

# 숨겨진 파일이 발견되면 "발견" 메시지와 함께 취약으로 표시
if [ -z "$hidden_files" ]; then
    echo "  [양호] 숨겨진 파일 및 디렉토리가 없음"
else
    echo "  [취약] 숨겨진 파일 및 디렉토리가 발견됨"
    # 숨겨진 파일 목록은 출력하지 않음
fi
