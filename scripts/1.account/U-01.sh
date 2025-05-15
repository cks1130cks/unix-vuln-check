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

CODE "[U-01] root 계정 원격 터미널 접속 차단 설정 점검"

BAR

SSHD_CONFIG="/etc/ssh/sshd_config"

# sshd 서비스 상태 확인
SSH_STATUS=$(systemctl is-active sshd)

if [ "$SSH_STATUS" = "active" ]; then
  INFO "SSH 원격 터미널 서비스가 활성화되어 있습니다."

  if [ -f "$SSHD_CONFIG" ]; then
    INFO "$SSHD_CONFIG 설정 파일이 존재합니다."

    PERMIT_SETTING=$(grep -i "^PermitRootLogin" "$SSHD_CONFIG")

    if [[ "$PERMIT_SETTING" =~ [Yy][Ee][Ss] ]]; then
      WARN "root 계정의 원격 접속이 허용되어 있습니다. -> 설정: $PERMIT_SETTING"
    elif [[ "$PERMIT_SETTING" =~ [Nn][Oo] ]]; then
      OK "root 계정의 원격 접속이 차단되어 있습니다. -> 설정: $PERMIT_SETTING"
    elif [[ -z "$PERMIT_SETTING" ]]; then
      WARN "PermitRootLogin 설정이 존재하지 않습니다. 기본값은 yes일 수 있습니다."
    else
      INFO "PermitRootLogin 설정 값: $PERMIT_SETTING"
    fi

  else
    WARN "$SSHD_CONFIG 파일이 존재하지 않습니다. 수동 점검이 필요합니다."
  fi

else
  OK "SSH 원격 터미널 서비스를 사용하지 않습니다."
fi

# 최종 결과 출력
cat "$RESULT"
