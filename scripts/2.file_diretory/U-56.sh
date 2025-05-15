#!/bin/bash

echo "U-56: UMASK 설정 점검"

umask_value=$(grep -i 'umask' /etc/profile | grep -v '^#' | head -n 1)

echo "  /etc/profile 내 UMASK 설정 내용: $umask_value"

if [[ "$umask_value" =~ umask[[:space:]]+022 ]]; then
  echo "  [양호] UMASK 값이 022로 설정되어 있습니다."
else
  echo "  [취약] UMASK 값이 022로 설정되어 있지 않습니다."
  echo "         보안을 위해 UMASK 값을 022로 설정하는 것이 권장됩니다."
fi
