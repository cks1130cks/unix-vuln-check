#!/bin/bash

echo "U-05: root 홈, 패스(PATH) 디렉토리 권한 및 패스(PATH) 설정"

ROOTPATH=$(su - root -c 'echo $PATH')

if echo "$ROOTPATH" | grep -Eq '(^\.|:\.|::)'; then
  echo "  [취약] (PATH 환경변수에 '.' 이 맨 앞이나 중간에 포함되어 있습니다.)"
else
  echo "  [양호] (PATH 환경변수에 '.' 이 맨 앞이나 중간에 포함되지 않았습니다.)"
fi
