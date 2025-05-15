#!/bin/bash
echo "U-13: SUID/SGID 설정 파일 점검"
find / -user root -type f \( -perm -04000 -o -perm -02000 \) -xdev > /tmp/U13_find_result.txt 2>/dev/null
if [ -s /tmp/U13_find_result.txt ]; then
  echo "  [취약] (SUID/SGID 설정된 파일 존재)"
  cat /tmp/U13_find_result.txt
else
  echo "  [양호] (SUID/SGID 설정된 파일 없음)"
fi