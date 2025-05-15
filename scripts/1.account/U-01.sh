#!/bin/bash
echo "U-01: root 계정 원격 터미널 접속 차단 설정 점검"

SSHD_CONFIG="/etc/ssh/sshd_config"

SSH_STATUS=$(systemctl is-active sshd)

if [ "$SSH_STATUS" = "active" ]; then
  if [ -f "$SSHD_CONFIG" ]; then
    PERMIT_SETTING=$(grep -i "^PermitRootLogin" "$SSHD_CONFIG")

    if [[ "$PERMIT_SETTING" =~ [Yy][Ee][Ss] ]]; then
      echo "  [취약] (root 계정의 원격 접속이 허용되어 있음: $PERMIT_SETTING)"
    elif [[ "$PERMIT_SETTING" =~ [Nn][Oo] ]]; then
      echo "  [양호] (root 계정의 원격 접속이 차단되어 있음: $PERMIT_SETTING)"
    elif [[ -z "$PERMIT_SETTING" ]]; then
      echo "  [취약] (PermitRootLogin 설정이 없음, 기본값 yes일 수 있음)"
    else
      echo "  [정보] (PermitRootLogin 설정 값: $PERMIT_SETTING)"
    fi
  else
    echo "  [취약] ($SSHD_CONFIG 파일이 없음)"
  fi
else
  echo "  [양호] (SSH 원격 터미널 서비스를 사용하지 않음)"
fi
