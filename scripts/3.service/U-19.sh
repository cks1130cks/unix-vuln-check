#!/bin/bash

echo "U-19: finger 서비스 비활성화 점검"

echo "  점검 서비스: finger"

if pgrep -x finger > /dev/null 2>&1 || systemctl is-active --quiet finger; then
  echo "  [취약] finger 서비스가 활성화 되어 있음"
else
  echo "  [양호] finger 서비스가 비활성화 되어 있음"
fi
