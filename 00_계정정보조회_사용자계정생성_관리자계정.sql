-- 한 줄 주석 (자바에서는 //)
/*
    여러 줄 주석 (자바와 동일!)
*/

-- 현재 모든 계정 정보 조회
SELECT * FROM DBA_USERS;
-- 명령문 실행: 상단의 재생 버튼 또는 <Ctrl> +<Enter>

-- 사용자 계정 추가(생성)
-- ID: C##KH    PW: KH 계정 생성
CREATE USER C##KH IDENTIFIED BY KH;

-- 사용자 계정 생성 후 권한 부여 (최소한의 권한: 접속, 데이터 관리)
GRANT CONNECT, RESOURCE TO C##KH;
-- CONNECT: 연결 권한
-- RESOURCE: DB에서 객체(테이블, 시퀀스, 프로시저, ...)의 생성 권한

-- 테이블 스페이스 설정
ALTER USER C##KH DEFAULT TABLESPACE USERS QUOTA UNLIMITED ON USERS;
-- QUOTA: 한도, 몫, 최소 득표수
-- 탭의 제목 부분이 기울임체로 되어 있으면 저장 안 된 것!!!
