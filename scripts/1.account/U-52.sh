#!/bin/bash

echo "U-52: 동일한 UID 0 계정 존재 여부 점검"

PASSWD_FILE="/etc/passwd"
echo "  점검 파일: $PASSWD_FILE"

# UID가 0인 계정 목록 추출
uids=$(awk -F: '$3 == 0 {print $1}' "$PASSWD_FILE")

# root 제외한 UID 0 계정 추출
extra_root_accounts=$(echo "$uids" | grep -vw "root")

if [ -n "$extra_root_accounts" ]; then
    echo "  [취약] root 외에 UID 0 권한을 가진 계정이 존재합니다:"
    echo "         권한이 과도하게 부여된 계정은 보안 위험을 초래할 수 있습니다."
    echo "$extra_root_accounts" | sed 's/^/           - /'
    echo "         필요 없는 계정은 삭제하거나 권한을 재조정하시기 바랍니다."
else
    echo "  [양호] UID 0 권한은 root 계정에만 할당되어 있습니다."
fi
