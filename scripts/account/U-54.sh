echo "U-54: Session Timeout 설정"
tmout=$(grep -E '^TMOUT=' /etc/profile /etc/bashrc /etc/profile.d/*.sh 2>/dev/null | awk -F= '{print $2}' | sort -n | head -1)
if [ -n "$tmout" ] && [ "$tmout" -le 600 ]; then
    echo "  TMOUT 설정값: $tmout"
    echo "  [양호]"
else
    echo "  TMOUT 설정값: $tmout"
    echo "  [취약]"
fi
echo
