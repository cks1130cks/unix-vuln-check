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

MINLEN=$(FindPatternReturnValue "$PWQUALITY_CONF" "minlen")

if [ "$MINLEN" = "None" ]; then
  echo "  [취약] (패스워드 최소 길이 설정 누락)"
else
  if [ "$MINLEN" -ge 8 ]; then
    if IsFindPattern "$PWQUALITY_CONF" "dcredit" &&
       IsFindPattern "$PWQUALITY_CONF" "ucredit" &&
       IsFindPattern "$PWQUALITY_CONF" "lcredit" &&
       IsFindPattern "$PWQUALITY_CONF" "ocredit"; then
      echo "  [양호] (복잡성 설정 양호: minlen=$MINLEN, d/u/l/o credit 설정 존재)"
    else
      echo "  [취약] (minlen은 충분하나 복잡성 설정 일부 누락)"
    fi
  else
    echo "  [취약] (패스워드 최소 길이 $MINLEN < 8)"
  fi
fi
