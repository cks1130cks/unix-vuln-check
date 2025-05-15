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

# PAM 패턴 추출 함수
PAM_FindPatternReturnValue() {
  PAM_FILE=$1
  PAM_PATTERN=$2
  if egrep -v '^#|^$' "$PAM_FILE" | grep -q "$PAM_PATTERN"; then
    ReturnValue=$(egrep -v '^#|^$' "$PAM_FILE" | grep "$PAM_PATTERN" | awk -F= '{print $2}' | tr -d ' ')
  else
    ReturnValue=None
  fi
  echo "$ReturnValue"
}

# 점검 시작
TMP1="U-03.log"
> "$TMP1"

BAR

CODE "[U-03] 계정 잠금 임계값 설정"

cat << EOF >> "$RESULT"
[양호]: 계정 잠금 임계값이 5이하의 값으로 설정되어 있는 경우
[취약]: 계정 잠금 임계값이 설정되어 있지 않거나, 5이하의 값으로 설정되지 않은 경우
EOF

BAR

PAM_SYSTEM_AUTH="/etc/pam.d/system-auth"

# PAM 설정 점검
Ret1=$(PAM_FindPatternReturnValue "$PAM_SYSTEM_AUTH" "pam_tally2.so deny")
Ret2=$(PAM_FindPatternReturnValue "$PAM_SYSTEM_AUTH" "pam_tally2.so unlock_time")

if [ "$Ret1" != "None" ] && [ "$Ret2" != "None" ]; then
  if [ "$Ret1" -le 5 ]; then
    OK "계정 잠금 임계값이 5 이하의 값으로 설정되어 있는 경우입니다."
  else
    WARN "계정 잠금 임계값이 설정되어 있지만, 5 이상의 값으로 설정되어 있습니다."
  fi
else
  WARN "계정 잠금 임계값이 설정되어 있지 않거나, 5 이하의 값으로 설정되지 않은 경우입니다."
fi

# 최종 결과 출력
cat "$RESULT"

