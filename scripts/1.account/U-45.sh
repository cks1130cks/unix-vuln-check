#!/bin/bash

echo "U-45: root 계정 su 명령 제한 점검"

SU_BIN="/usr/bin/su"
echo "  점검 파일: $SU_BIN"

if [ -f "$SU_BIN" ]; then
  PERM=$(ls -l "$SU_BIN" | awk '{print $1}')
  OWNER=$(ls -l "$SU_BIN" | awk '{print $3}')
  GROUP=$(ls -l "$SU_BIN" | awk '{print $4}')

  echo "  현재 권한: $PERM (소유자: $OWNER, 그룹: $GROUP)"

  if [[ "$PERM" == "-rwsr-x---" && "$GROUP" == "wheel" ]]; then
    echo "  [양호] su 명령어에 대한 접근이 wheel 그룹으로 제한되어 있습니다."
    echo "         해당 설정은 일반 사용자의 무분별한 su 사용을 방지합니다."
  else
    echo "  [취약] su 명령어의 권한 또는 그룹 설정이 미흡합니다."
    echo "         권장 설정: -rwsr-x--- 및 그룹을 wheel 또는 제한된 그룹으로 설정"
    echo "         수정 예시:"
    echo "           chmod 4750 /usr/bin/su"
    echo "           chgrp wheel /usr/bin/su"
  fi
else
  echo "  [정보] su 명령어 파일($SU_BIN)이 존재하지 않습니다."
fi
