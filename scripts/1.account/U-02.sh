#!/bin/bash

# 기본 변수 정의
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

# 값 추출 함수
FindPatternReturnValue() {
  if egrep -v '^#|^$' "$1" | grep -q "$2" ; then
    ReturnValue=$(egrep -v '^#|^$' "$1" | grep "$2" | awk -F= '{print $2}' | tr -d ' ')
  else
    ReturnValue=None
  fi
  echo "$ReturnValue"
}

IsFindPattern() {
  if egrep -v '^#|^$' "$1" | grep -q "$2" ; then
    return 0
  else
    return 1
  fi
}

# 메인 스크립트 시작
TMP1="U-02.log"
> "$TMP1"

BAR
CODE "[U-02] 패스워드 복잡성 검사"

cat << EOF >> "$RESULT"
[양호]: 영문 숫자 특수문자가 혼합된 8 글자 이상의 패스워드가 설정된 경우.
[취약]: 영문 숫자 특수문자 혼합되지 않은 8 글자 미만의 패스워드가 설정된 경우.
EOF
BAR

INFO "/etc/security/pwquality.conf 파일을 점검합니다"

echo >> "$TMP1"
echo "다음은 /etc/security/pwquality.conf 파일을 해석할 때 사용하는 내용입니다" >> "$TMP1"
echo "=============================================================" >> "$TMP1"
egrep -v '(^$|^#)' /etc/security/pwquality.conf >> "$TMP1"

cat << EOF >> "$TMP1"
=============================================================
다음은 /etc/security/pwquality.conf 파일을 해석할 때 사용하는 내용입니다.

minlen   : 패스워드 최소 길이입니다.
minclass : 패스워드 class 지정입니다.
lcredit  : 패스워드 소문자 포함 지정입니다.
ucredit  : 패스워드 대문자 포함 지정입니다.
dcredit  : 패스워드 숫자 포함 지정입니다.
ocredit  : 패스워드 특수문자 포함 지정입니다.

=============================================================
다음은 /etc/security/pwquality.conf 파일의 내용이 없으면,

1) 기본값을 사용하는 경우입니다. 이 경우, 패스워드 정책에 맞지 않습니다.
   따라서, 반드시 정책을 변경할 것을 권장합니다.

2) 정책을 변경하는 경우에는 다음과 같은 명령어를 통해 설정할 수 있습니다.

# authconfig --passminlen=8 --passminclass=3 \\
--enablereqlower --disablerequpper --enablereqdigit \\
--enablereqother --update
=============================================================
EOF

# 실제 설정 파일 (분석용 사본이 있는 경우 사용)
PWQUALITY_CONF="/etc/security/pwquality.conf"

VALUE1=$(FindPatternReturnValue "$PWQUALITY_CONF" "minlen")

if [ "$VALUE1" = "None" ]; then
  WARN "패스워드의 최소 길이 설정이 누락되어 있음!"
else
  if [ "$VALUE1" -ge 8 ]; then
    IsFindPattern "$PWQUALITY_CONF" "dcredit"; Ret1=$?
    IsFindPattern "$PWQUALITY_CONF" "ucredit"; Ret2=$?
    IsFindPattern "$PWQUALITY_CONF" "lcredit"; Ret3=$?
    IsFindPattern "$PWQUALITY_CONF" "ocredit"; Ret4=$?

    if [ $Ret1 -eq 0 ] && [ $Ret2 -eq 0 ] && [ $Ret3 -eq 0 ] && [ $Ret4 -eq 0 ]; then
      OK "영문, 숫자, 특수문자가 혼합된 8글자 이상의 패스워드를 사용하고 있습니다."
    else
      WARN "패스워드가 8글자 이상이지만 dcredit, ucredit, lcredit, ocredit 중 설정이 누락된 항목이 있습니다."
    fi
  else
    WARN "패스워드의 최소 길이 설정이 8글자 미만으로 되어 있음"
  fi
fi

# 결과 출력
cat "$RESULT"

