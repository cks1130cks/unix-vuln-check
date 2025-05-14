echo "U-18: 접속 IP 및 포트 제한 점검"

# 취약 포트 추출 (0.0.0.0 또는 ::: 로 바인딩된 포트만 필터링)
vulnerable_ports=$(netstat -tulnp 2>/dev/null | grep -E '0\.0\.0\.0|:::' | awk '{print $4}' | sort | uniq)

if [ -n "$vulnerable_ports" ]; then
    echo "  [취약] 다음 포트들이 모든 IP에 바인딩되어 있습니다:"
    echo "  $vulnerable_ports"
else
    echo "  [양호] 모든 포트가 특정 IP에 바인딩되어 있습니다."
fi
