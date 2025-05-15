#!/bin/bash

echo "U-06: 소유자 없는 파일 점검"

orphan_files=$(find / \( -nouser -o -nogroup \) -print 2>/dev/null)

if [ -n "$orphan_files" ]; then
    echo "  [취약] 소유자 없는 파일 존재:"
    echo "  $orphan_files"
else
    echo "  [양호] 소유자 없는 파일 없음."
fi
