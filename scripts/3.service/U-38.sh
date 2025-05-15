#!/bin/bash
echo "U-38: Apache manual 디렉터리 존재 확인"
if [ -d /var/www/manual ] || [ -d /var/www/html/manual ]; then
    echo "  [취약] (manual 디렉터리 존재)"
else
    echo "  [양호] (manual 디렉터리 없음)"
fi
