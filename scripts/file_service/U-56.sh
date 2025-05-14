echo "===== U-56: UMASK 설정 ====="
umask_value=$(grep -i 'umask' /etc/profile)

if [[ "$umask_value" =~ "umask 022" ]]; then
  echo "U-56 : 양호 - UMASK 값이 022로 설정되어 있습니다."
else
  echo "U-56 : 취약 - UMASK 값이 022로 설정되어 있지 않습니다."
fi
