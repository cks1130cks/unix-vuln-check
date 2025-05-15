#!/bin/bash

echo "U-04: 패스워드 파일 보호 점검"

PASSFILE="/etc/passwd"
SHADOWFILE="/etc/shadow"

echo "  점검 대상 파일:"
echo "    - $PASSFILE"
echo "    - $SHADOWFILE"

CheckEncryptedPasswd() {
  # 쉐도우 파일에서 root 계정의 패스워드 필드 확인
  EncryptedPasswdField=$(grep '^root:' "$1" | awk -F: '{print $2}')
  
  if [[ "$EncryptedPasswdField" == "!" || "$EncryptedPasswdField" == "*" || -z "$EncryptedPasswdField" ]]; then
    echo "None"
    return
  fi

  # $알고리즘$... 형태에서 알고리즘 코드 추출
  AlgoCode=$(echo "$EncryptedPasswdField" | awk -F'$' '{print $2}')
  
  case "$AlgoCode" in
    1)
      echo "MD5"
      ;;
    2a)
      echo "BCRYPT"
      ;;
    5)
      echo "SHA256"
      ;;
    6)
      echo "SHA512"
      ;;
    *)
      echo "Unknown"
      ;;
  esac
}

if [ -f "$PASSFILE" ] && [ -f "$SHADOWFILE" ]; then
  AlgoType=$(CheckEncryptedPasswd "$SHADOWFILE")
  
  case "$AlgoType" in
    None)
      echo "  [취약] root 계정의 패스워드가 설정되어 있지 않거나 잠김(!, *) 상태입니다."
      ;;
    SHA512)
      echo "  [양호] root 계정 패스워드가 SHA-512 알고리즘으로 암호화되어 있습니다. (권장 알고리즘)"
      ;;
    MD5|BCRYPT|SHA256)
      echo "  [주의] root 계정 패스워드가 $AlgoType 방식으로 암호화되어 있습니다."
      echo "         가능하면 SHA-512 방식으로 암호화하는 것을 권장합니다."
      ;;
    Unknown)
      echo "  [주의] root 계정 패스워드의 암호화 방식이 식별되지 않았습니다."
      echo "         수동 확인을 권장합니다."
      ;;
    *)
      echo "  [취약] 알 수 없는 오류가 발생했습니다. 수동 확인 필요."
      ;;
  esac
else
  echo "  [취약] /etc/shadow 파일이 존재하지 않습니다. 쉐도우 패스워드를 사용하지 않는 것으로 보입니다."
fi
