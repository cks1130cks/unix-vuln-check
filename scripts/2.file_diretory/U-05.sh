#!/bin/bash

echo "U-05: root 홈, PATH 디렉토리 권한 및 PATH 환경변수 설정 점검"

# root 사용자로 실행한 PATH 환경변수 가져오기
ROOTPATH=$(su - root -c 'echo $PATH')

echo "  root PATH 환경변수: $ROOTPATH"

# PATH 내에 '.' 포함 여부 점검 (맨 앞, 중간, 또는 연속된 콜론 사이)
if echo "$ROOTPATH" | grep -Eq '(^\.|:\.|::)'; then
  echo "  [취약] PATH 환경변수에 '.'이 포함되어 있습니다."
  echo "         이는 현재 디렉토리가 PATH에 포함되어 있어 보안 취약점이 될 수 있습니다."
  echo "         PATH 환경변수에서 '.' 제거를 권장합니다."
else
  echo "  [양호] PATH 환경변수에 '.'이 포함되어 있지 않습니다."
fi
