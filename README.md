# linux-security-audit-script

학교 실습 및 보안 가이드라인 공부 목적으로 작성한 리눅스 서버 취약점 점검 스크립트입니다.  
KISA(한국인터넷진흥원) 주요정보통신기반시설 취약점 가이드라인을 참고해서 수작업으로 확인하던 항목 22개를 Bash 스크립트로 자동화했습니다

1. 기본 계정 관리 : ip, uucp, nuucp 등 불필한 잔여 계정 점검(/etc/passwd)
2. root 계정 관리 : root 외 uid를 0으로 사용한 관리자 권한 계정 여부 점검(/etc/passwd)
3. 패스워드 파일 권한 관리 : /etc/passwd소유자 및 파일 접근권한(644/rw-r--r--)점검
4. 그룹파일권환관리 : /etc/group 소유자 및 파일 접근 권한 점검(644/rw-r--r--)
5. 패스워드 정책 관리 : 패스워드 최소 길이, 최대, 최소 사용기간 설정 점검(/etc/login.defs)
6. 시스템 기본 계정 쉘 제한 : 불필요한 시스템 데몬 계정의 비정상 쉘(/bin/bash)부여 점검(/etc/passwd)
7. root계정 su 제한 : wheel 그룹 기반의 su명령어 사용 권한 통제 점검(/etc/pam.d/su)
8. shadow 파일 권한 관리 : /etc/shadow 파일 접근권한(400/r-------)및 소유자 점검
9. UMASK 관리 : 시스템 기본 umask설정값(022이상) 점검(/etc/login.defs)
10. SetUID/SetGID 파일 관리 : 주요 시스템 바이너리 파일의 setuid/setgid 불필요한 권한 부여 점검
11. 슈퍼데몬 설정 파일 관리 : /etc/xinetd.conf 파일 접근 권한(600/rw-------) 및 소유자 점검
12. 명령어 히스토리 파일 권한 관리 : 사용자 홈 디렉터리 내 .history파일 접근 권한  점검
13. 환경설정 파일 권한 관리 : /etc/profile 환경설정 파ㅏ일 소유자 및 권한 설정
14. 호스트 파일 권한 관리 : /etc/hosts 파일 소유자 및 접근 권한(644/rw-r--r--)점검
15. 시스템 접속 배너 파일 관리 : etc/issue 시스템 정보 노출 방지 및 파일 권한 점검
16. 홈 디렉터리 권하 ㄴ관리 : 사용자별 홈 디렉터리 접근 권한 점검
17. 홈 디렉터리 권한 관리 : .bashrc , .bash_profile 등 사용자 설정 파일 권한 점검
18. 주요 시스템 디렉터리 권한 관리 : /sbin,/bin,/etc 등 주요 실행 경로 쓰기 권한 점검
19. 환경 변수 PATH경로 관리 : PATH 환경변수 내 현재 디렉터리 취약점 점검
20. root 원격 접속 제한 : 콘솔 외 직접 root 로그인 제한 설정 점검(/etc/pam.d/login)
21. 시스템 부팅/ 설정 파일 권한 관리 : /etc/rc*.d, /etc/inittab등 주요 설정 파일 권한 점검
22. 취약한 RPC 서비스 비활성화: Buffer Overflow threats가 있는 RPC 관련 서비스 구동 여부 점검(/etc/xinetd.d)


실행방법
chmod +x filename.sh 


./filename.sh
