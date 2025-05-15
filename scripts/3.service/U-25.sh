#!/bin/bash
echo "U-25: NFS 접근 통제 설정 점검"

FILE="/etc/exports"

echo "  점검 대상 파일: $FILE"

if [ -f "$FILE" ]; then
  # 접근 통제 관련 설정이 존재하는지 확인 (root, rw, ro, no_root_squash 중 하나라도 있으면 양호 판단)
  matched_lines=$(grep -E 'root|rw|ro|no_root_squash' "$FILE")
  if [ -n "$matched_lines" ]; then
    count=$(echo "$matched_lines" | wc -l)
    echo "  [양호] $FILE에 적절한 접근 통제 설정이 $count건 존재합니다."
    echo "  -- 설정 예시 (최대 10줄) --"
    echo "$matched_lines" | head -n 10 | sed 's/^/    /'
  else
    echo "  [취약] $FILE에 적절한 접근 통제 설정이 없습니다."
    echo "    NFS 공유에 대한 root 권한 제한(root_squash), 읽기/쓰기 권한(rw/ro) 등의 설정이 필요합니다."
  fi
else
  echo "  [양호] $FILE 파일이 존재하지 않습니다."
  echo "    (NFS 서비스를 사용하지 않는 경우 이 점검은 양호로 판단합니다.)"
fi
