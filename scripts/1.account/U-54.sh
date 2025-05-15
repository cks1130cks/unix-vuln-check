#!/bin/bash

echo "U-54: Session Timeout (TMOUT) 설정 점검"

# 점검 대상 파일들
FILES=("/etc/profile" "/etc/bashrc" /etc/profile.d/*.sh)

echo "  점검 대상 파일:"
for f in "${FILES[@]}"; do
  echo "    $f"
done

# TMOUT 설정값들 중 최소값 추출
tmout=$(grep -E '^TMOUT=' "${FILES[@]}" 2>/dev/null | awk -F= '{print $2}' | sort -n | head -1)

if [ -n "$tmout" ]; then
    echo "  발견된 TMOUT 설정값: $tmout 초"
    if [ "$tmout" -le 600 ]; then
        echo "  [양호] 세션 자동 타임아웃이 600초(10분) 이하로 설정되어 있습니다."
    else
        echo "  [취약] 세션 자동 타임아웃이 600초(10분) 초과로 설정되어 있습니다."
        echo "         보안을 위해 600초 이하로 설정하는 것을 권장합니다."
    fi
else
    echo "  [취약] TMOUT 설정이 발견되지 않았습니다."
    echo "         세션 자동 로그아웃 설정을 권장합니다."
fi
