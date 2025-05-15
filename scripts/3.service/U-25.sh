#!/bin/bash

echo "U-25: NFS 접근 통제 점검"

# 1. NFS 서비스 상태 확인 (systemd 기반)
NFS_SERVICE=$(systemctl is-active nfs-server 2>/dev/null || echo "unknown")

if [ "$NFS_SERVICE" != "active" ]; then
  echo "  [양호] NFS 서비스가 실행 중이지 않습니다."
  exit 0
else
  echo "  [정보] NFS 서비스가 실행 중입니다."
fi

# 2. /etc/exports 파일 존재 및 내용 확인
EXPORTS_FILE="/etc/exports"

if [ ! -f "$EXPORTS_FILE" ]; then
  echo "  [양호] NFS 공유 설정 파일($EXPORTS_FILE)이 존재하지 않습니다."
  exit 0
fi

echo "  [정보] /etc/exports 파일 내용:"
cat "$EXPORTS_FILE"

# 3. everyone(*) 공유 설정 검사
EVERYONE_SHARES=$(grep -E '^\s*[^#]+[\t ]+\*' "$EXPORTS_FILE")

if [ -n "$EVERYONE_SHARES" ]; then
  echo "  [취약] everyone(*) 공유 설정이 발견되었습니다:"
  echo "$EVERYONE_SHARES"
else
  echo "  [양호] everyone(*) 공유 설정이 없습니다."
fi

echo "점검 완료."
