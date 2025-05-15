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

# 암호화된 패스워드 확인 함수
CheckEncryptedPasswd() {
  SFILE=$1
  EncryptedPasswdField=$(grep '^root' "$SFILE" | awk -F: '{print $2}' | awk -F'$' '{print $2}')
  case $EncryptedPasswdField in
    1|2a|5) echo "WarnTrue" ;;
    6) echo "TrueTrue" ;;
    *) echo "None" ;;
  esac
}

# 점검 시작
BAR

CODE "[U-04] 패스워드 파일 보호"

cat << EOF >> "$RESULT"
[양호]: 쉐도우 패스워드를 사용하거나, 패스워드를 암호화하여 저장하는 경우
[취약]: 쉐도우 패스워드를 사용하지 않고, 패스워드를 암호화하여 저장하지 않는 경우
EOF

BAR

PASSFILE="/etc/passwd"
SHADOWFILE="/etc/shadow"

# 패스워드 파일 및 쉐도우 파일 존재 여부 점검
if [ -f "$PASSFILE" ] && [ -f "$SHADOWFILE" ]; then
  Ret1=$(CheckEncryptedPasswd "$SHADOWFILE")

  case $Ret1 in
    None)
      WARN "쉐도우 패스워드를 사용하지만, 패스워드가 암호화 되어 있지 않습니다." ;;
    TrueTrue)
      OK "쉐도우 패스워드를 사용하거나, 패스워드를 암호화하여 저장하고 있습니다." ;;
    WarnTrue)
      OK "쉐도우 패스워드를 사용하거나, 패스워드를 암호화하여 저장하고 있습니다."
      INFO "SHA-512 알고리즘을 사용할 것을 권장합니다." ;;
    *)
      : ;;
  esac
else
  WARN "쉐도우 패스워드를 사용하지 않고 있습니다."
fi

# 최종 결과 출력
cat "$RESULT"
echo

