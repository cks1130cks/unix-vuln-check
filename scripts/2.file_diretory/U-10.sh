#!/bin/bash

# 로그 파일 정의
LOG=check.log
RESULT=result.log
> $LOG
> $RESULT

# 상태 출력 함수들

# 바 형태의 구분선 출력
BAR() {
    echo "========================================================================" >> $RESULT
}

# 코드 상태 출력 함수
CODE(){
    echo -e '\033[36m'$*'\033[0m'
} >> $RESULT

# 정보 상태 출력 함수
INFO() {
    echo -e '\033[35m'"[ 정보 ] : $*"'\033[0m'
} >> $RESULT

# 경고 상태 출력 함수
WARN() {
    echo -e '\033[31m'"[ 취약 ] : $*"'\033[0m'
} >> $RESULT

# 양호 상태 출력 함수
OK() {
    echo -e '\033[32m'"[ 양호 ] : $*"'\033[0m'
} >> $RESULT

# 스크립트 이름 추출 함수
SCRIPTNAME() {
    basename $0 | awk -F. '{print $1}'
}

# 권한 체크 함수
check_perm() {
    FILE=$1
    PERM=$2
    PERM_DESC=$3
    FILEUSER=$4

    if [ ! -f $FILE ]; then
        echo "[ WARN ] : $FILE 파일이 존재하지 않습니다." >> $RESULT
        return
    fi

    # 파일 소유자와 권한을 확인
    FILE_PERM=$(stat -c %a $FILE)
    FILE_OWNER=$(stat -c %U $FILE)

    # 권한이 맞는지, 소유자가 맞는지 확인
    if [ "$FILE_OWNER" != "$FILEUSER" ]; then
        echo "[ WARN ] : $FILE 소유자가 $FILEUSER가 아닙니다. 현재 소유자: $FILE_OWNER" >> $RESULT
    fi

    if [ "$FILE_PERM" != "$PERM" ]; then
        echo "[ WARN ] : $FILE 권한이 $PERM ($PERM_DESC)가 아닙니다. 현재 권한: $FILE_PERM" >> $RESULT
    fi

    # 모든 것이 양호하면 OK 메시지 출력
    if [ "$FILE_OWNER" == "$FILEUSER" ] && [ "$FILE_PERM" == "$PERM" ]; then
        echo "[ OK ] : $FILE 권한과 소유자가 양호합니다." >> $RESULT
    fi
}

# 실행 시작 부분
TMP1=$(SCRIPTNAME).log

> $TMP1

# 결과 출력 부분 시작
BAR

CODE [U-21] /etc/xinetd.conf 파일 소유자 및 권한 설정

cat << EOF >> $RESULT
[양호]: /etc/xinetd.conf 파일의 소유자가 root이고, 권한이 600인 경우
[취약]: /etc/xinetd.conf 파일의 소유자가 root가 아니거나, 권한이 600이 아닌경우
EOF

BAR

# 점검할 파일 및 설정
FILE=/etc/xinetd.conf
PERM1=600
PERM2=rw-------

FILEUSER=root

# 권한 점검 함수 호출
check_perm $FILE $PERM1 $PERM2 $FILEUSER

# 결과 출력
cat $RESULT
echo ; echo

