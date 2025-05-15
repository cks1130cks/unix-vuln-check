#!/bin/bash

# 기본 파일 및 초기화
LOG="check.log"
RESULT="result.log"
> "$LOG"
> "$RESULT"

# 공통 출력 함수들
BAR() {
  echo "========================================================================" >> "$RESULT"
}

OK() {
  echo -e '\033[32m'"[ 양호 ] : $*"'\033[0m'
} >> "$RESULT"

WARN() {
  echo -e '\033[31m'"[ 취약 ] : $*"'\033[0m'
} >> "$RESULT"

INFO() { 
  echo -e '\033[35m'"[ 정보 ] : $*"'\033[0m'
} >> "$RESULT"

CODE() {
  echo -e '\033[36m'"$*"'[0m'
} >> "$RESULT"

# 점검 시작
BAR

CODE "[U-05] root PATH 설정 점검"

cat << EOF >> "$RESULT"
[양호]
PATH 환경변수에 '.' 또는 '::'이 포함되지 않은 경우

[취약]
PATH 환경변수에 '.' 또는 '::'이 맨 앞이나 중간에 포함된 경우
EOF

BAR

# PATH 점검 로직
ROOT_PATH=$(echo "$PATH")

if echo "$ROOT_PATH" | grep -qE '(^\.|::|:\.:|:\.$|^:|:$)'; then
  WARN "PATH 변수에 보안상 위험한 항목이 포함되어 있습니다. (PATH: $ROOT_PATH)"
else
  OK "PATH 변수 설정이 적절합니다. (PATH: $ROOT_PATH)"
fi

# 최종 결과 출력
cat "$RESULT"
