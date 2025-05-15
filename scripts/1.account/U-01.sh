#!/bin/bash

# 기본 파일 및 초기화
LOG="check.log"
RESULT="result.log"
> "$LOG"
> "$RESULT"

# 결과 출력용 번호 (기본값)
NUM=1

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

cat << EOF >> "$RESULT"
[양호]
원격 터미널 서비스를 사용하지 않거나, 사용 시 root 직접 접속을 차단한 경우

[취약]
원격 터미널 서비스 사용 시 root 직접 접속을 허용한 경우
EOF

BAR

SSHD_CONFIG="/etc/ssh/sshd_config"

# sshd 서비스 상태 확인
SSH_STATUS=$(systemctl is-active sshd)

if [ "$SSH_STATUS" = "active" ]; then
  INFO "SSH 원격 터미널 서비스가 활성화되어 있습니다."

  if [ -f "$SSHD_CONFIG" ]; then
    INFO "$SSHD_CONFIG 설정 파일이 존재합니다."

    # PermitRootLogin 설정 값 확인
    PERMIT_SETTING=$(grep -i "^PermitRootLogin" "$SSHD_CONFIG")

    if [[ "$PERMIT_SETTING" =~ "yes" ]]; then
      WARN "취약: root 계정의 원격 접속이 허용되어 있습니다. -> 설정: $PERMIT_SETTING"
    elif [[ "$PERMIT_SETTING" =~ "no" ]]; then
      OK "양호: root 계정의 원격 접속이 차단되어 있습니다. -> 설정: $PERMIT_SETTING"
    elif [[ -z "$PERMIT_SETTING" ]]; then
      WARN "취약: PermitRootLogin 설정이 없습니다. 기본값은 yes일 수 있습니다."
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

