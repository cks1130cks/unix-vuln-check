#!/bin/bash

echo "U-04: 패스워드 파일 보호 점검"

PASSFILE="/etc/passwd"
SHADOWFILE="/etc/shadow"

CheckEncryptedPasswd() {
  # root 계정 패스워드 필드의 암호화 알고리즘 식별
  EncryptedPasswdField=$(grep '^root' "$1" | awk -F: '{print $2}' | awk -F'$' '{print $2}')
  case $EncryptedPasswdField in
    1|2a|5) echo "WarnTrue" ;;  # md5, bcrypt, sha256 (권장 아님)
    6) echo "TrueTrue" ;;        # sha512 (권장)
    *) echo "None" ;;
  esac
}

if [ -f "$PASSFILE" ] && [ -f "$SHADOWFILE" ]; then
  Ret1=$(CheckEncryptedPasswd "$SHADOWFILE")
  case $Ret1 in
    None)
      echo "  [취약] (패스워드가 암호화 되어 있지 않음)"
      ;;
    TrueTrue)
      echo "  [양호] (SHA-512 암호화 패스워드 사용)"
      ;;
    WarnTrue)
      echo "  [양호] (암호화된 패스워드 사용, SHA-512 사용 권장)"
      ;;
    *)
      echo "  [취약] (알 수 없는 암호화 상태)"
      ;;
  esac
else
  echo "  [취약] (쉐도우 패스워드를 사용하지 않음)"
fi
