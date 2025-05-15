#!/bin/bash
echo "U-01: root 계정 원격 터미널 접속 차단 설정 점검"

SSHD_CONFIG="/etc/ssh/sshd_config"
SSH_STATUS=$(systemctl is-active sshd)

echo "  점검 파일: $SSHD_CONFIG"
echo "  SSH 서비스 상태: $SSH_STATUS"

if [ "$SSH_STATUS" = "active" ]; then
  if [ -f "$SSHD_CONFIG" ]; then
    # PermitRootLogin 설정 중 주석 처리되지 않은 마지막 줄 추출
    PERMIT_SETTING=$(grep -iE '^\s*PermitRootLogin' "$SSHD_CONFIG" | grep -v '^\s*#' | tail -n 1)
    # PermitRootLogin 설정 중 주석 처리된 마지막 줄 추출
    PERMIT_SETTING_COMMENTED=$(grep -iE '^\s*#\s*PermitRootLogin' "$SSHD_CONFIG" | tail -n 1)

    if [[ -z "$PERMIT_SETTING" ]]; then
      if [[ -n "$PERMIT_SETTING_COMMENTED" ]]; then
        echo "  [정보] PermitRootLogin 설정은 존재하나 주석 처리되어 있습니다."
        echo "         주석 처리된 설정 내용: $PERMIT_SETTING_COMMENTED"
        echo "         기본값은 'yes'일 수 있으니 확인이 필요합니다."
      else
        echo "  [취약] PermitRootLogin 설정이 존재하지 않습니다. (기본값: yes일 수 있음)"
        echo "         root 계정의 원격 접속이 허용될 가능성이 있습니다."
      fi
    else
      VALUE=$(echo "$PERMIT_SETTING" | awk '{print $2}' | tr -d '[:space:]')
      case "$VALUE" in
        [Yy][Ee][Ss])
          echo "  [취약] root 계정의 원격 접속이 허용되어 있습니다."
          echo "         설정 내용: $PERMIT_SETTING"
          ;;
        [Nn][Oo])
          echo "  [양호] root 계정의 원격 접속이 차단되어 있습니다."
          echo "         설정 내용: $PERMIT_SETTING"
          ;;
        *)
          echo "  [정보] PermitRootLogin 설정 값이 yes/no 이외로 지정되어 있습니다."
          echo "         설정 내용: $PERMIT_SETTING"
          ;;
      esac
    fi
  else
    echo "  [취약] SSH 설정 파일($SSHD_CONFIG)이 존재하지 않습니다."
  fi
else
  echo "  [양호] SSH 원격 터미널 서비스가 활성화되어 있지 않습니다."
fi
