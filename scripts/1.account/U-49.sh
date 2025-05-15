#!/bin/bash

echo "U-49: finger 서비스 비활성화 점검"

FINGER_CONFIG="/etc/xinetd.d/finger"
echo "  점검 파일: $FINGER_CONFIG"

if [ -f "$FINGER_CONFIG" ]; then
  # disable 항목의 값 추출
  DISABLE=$(grep -i '^disable' "$FINGER_CONFIG" | awk '{print $3}')
  
  if [ "$DISABLE" == "no" ]; then
    echo "  [취약] finger 서비스가 활성화되어 있습니다. (disable = no)"
    echo "         finger 서비스는 사용자 계정 정보를 노출시킬 수 있어 보안상 위험합니다."
    echo "         /etc/xinetd.d/finger 파일에서 'disable = yes'로 설정하거나 해당 파일을 삭제해야 합니다."
  elif [ "$DISABLE" == "yes" ]; then
    echo "  [양호] finger 서비스가 비활성화되어 있습니다. (disable = yes)"
  else
    echo "  [정보] disable 설정이 명확하지 않습니다. (disable = $DISABLE)"
  fi
else
  echo "  [양호] finger 서비스 설정 파일이 존재하지 않습니다."
  echo "         서비스가 설치되지 않았거나 비활성화된 것으로 판단됩니다."
fi
