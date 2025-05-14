#!/bin/bash

# 실행 대상 디렉토리
BASE_DIR="./scripts"

# 스크립트 실행 함수
run_scripts_in_dir() {
    local dir="$1"
    echo ">> [$dir] 디렉토리의 스크립트 실행 중..."

    for script in "$dir"/*.sh; do
        if [ -f "$script" ]; then
            bash "$script"
        fi
    done
}

# 하위 디렉토리 순회
for subdir in "$BASE_DIR"/*/; do
    run_scripts_in_dir "$subdir"
done

echo "✅ 모든 스크립트 실행 완료."
