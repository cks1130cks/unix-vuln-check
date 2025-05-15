#!/bin/bash
echo "[U-15] World Writable 파일 점검"
find / -type f -perm -0002 -exec ls -l {} \; > /tmp/U15_world_writable.txt 2>/dev/null
if [ -s /tmp/U15_world_writable.txt ]; then
  echo "결과: 취약 (World Writable 파일 존재)"
  cat /tmp/U15_world_writable.txt
else
  echo "결과: 양호 (World Writable 파일 없음)"
fi
