#!/bin/bash
echo "U-02: 패스워드 복잡성 설정 점검"

PWQUALITY_CONF="/etc/security/pwquality.conf"

FindPatternReturnValue() {
  if egrep -v '^#|^$' "$1" | grep -q "$2" ; then
    egrep -v '^#|^$' "$1" | grep "$2" | awk -F= '{print $2}' | tr -d ' '
  else
    echo "None"
  fi
}

IsFindPattern() {
  egrep -v '^#|^$' "$1" | grep -q "$2"
}

echo "  점검 파일: $PWQUALITY_CONF"

MINLEN=$(FindPatternReturnValue "$PWQUALITY_CONF" "minlen")

if [ "$MINLEN" = "None" ]; then
  echo "  [취약] 패스워드 최소 길이 설정(minlen) 항목이 누락되어 있습니다."
else
  if [ "$MINLEN" -ge 8 ]; then
    if IsFindPattern "$PWQUALITY_CONF" "dcredit" &&
       IsFindPattern "$PWQUALITY_CONF" "ucredit" &&
       IsFindPattern "$PWQUALITY_CONF" "lcredit" &&
       IsFindPattern "$PWQUALITY_CONF" "ocredit"; then
      echo "  [양호] 복잡성 설정 양호"
      echo "         minlen=$MINLEN, d/u/l/o credit 항목이 모두 설정되어 있습니다."
    else
      echo "  [취약] minlen은 충분하나, 복잡성 설정(dcredit, ucredit, lcredit, ocredit) 중 일부가 누락되었습니다."
    fi
  else
    echo "  [취약] 패스워드 최소 길이(minlen=$MINLEN)가 기준보다 작습니다. (기준: 8자 이상)"
  fi
fi
