#!/bin/bash

echo "U-50: 관리자 그룹에 최소한의 사용자 등록 점검"

GROUP_FILE="/etc/group"
TARGET_GROUP="root"

# root 그룹의 사용자 목록 추출 (4번째 필드)
group_users=$(grep "^${TARGET_GROUP}:" "$GROUP_FILE" | cut -d: -f4)

echo "  점검 그룹: $TARGET_GROUP"
echo "  등록된 사용자: ${group_users:-없음}"

# root 그룹에 등록된 사용자가 root 한 명이거나 아예 없으면 양호
if [ "$group_users" = "$TARGET_GROUP" ] || [ -z "$group_users" ]; then
    echo "  [양호] root 그룹에 최소한의 사용자만 등록되어 있습니다."
else
    echo "  [취약] root 그룹에 불필요한 사용자들이 추가로 등록되어 있습니다."
    echo "         관리자 권한이 필요한 사용자만 그룹에 포함되어야 합니다."
fi
