#!/bin/bash

echo "U-05: root PATH 설정 점검"

if echo "$PATH" | grep -qE '^\.|::|:\.:|:\.$'; then
    echo "  [취약] PATH 변수에 '.' 또는 '::' 이 맨 앞이나 중간에 존재함. (PATH: $PATH)"
else
    echo "  [양호] PATH 변수 설정 양호. (PATH: $PATH)"
fi
