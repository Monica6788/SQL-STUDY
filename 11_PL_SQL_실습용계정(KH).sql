/*
    PL/SQL: PROCEDURE LANGUAGE EXTENSION TO SQL
    
    - 오라클 자체에 내장되어 있는 절차적 언어
    - SQL(PL/SQL) 문장 내에 변수 정의, 조건문, 반복문 등을 지원
    
    [구조]
        [선언부] : DECLARE로 시작
                  변수, 상수 선언 및 초기화 부분 (생략 가능)
        실행부 : BEGIN으로 시작
                SQL문 또는 제어문(조건문, 반복문) 등의 로직 작성 부분 (생략 불가)
        [예외처리부]: EXCEPTION으로 시작
                    실행 중 예외(오류) 발생 시 해결하기 위한 부분 (생략 가능)
*/
-------------------------------------------------------------------------------
-- 화면에 출력하기 위한 설정 (DBMS_OUTPUT)
-- 접속할 때마다, 또는 새로운 워크시트 창을 열 때 실행해야 함!

SET SERVEROUTPUT ON;

-- HELLO ORACLE 출력
BEGIN
    DBMS_OUTPUT.PUT_LINE('HELLO ORACLE');
    DBMS_OUTPUT.PUT_LINE('너무 더워');
END;
/
--> 자바의 System.out.println()과 같은 역할!
-------------------------------------------------------------------------------
/*
    선언부 (DECLARE)
    : 변수 또는 상수를 선언하는 부분 (선언과 동시에 초기화도 가능)
    
    일반 타입 변수 (CONSTANT 쓰면 상수!)
    변수명 [CONSTANT] 데이터타입[ := 값];
    
    자바와의 차이점
    1) 자바에서는 자료형(데이터타입) 변수명; PL/SQL에서는 변수명 데이터타입;
    2) 자바에서는 대입 연산자가 =, PL/SQL에서는 := (SQL에서 =는 동등비교 연산자)
    3) 상수 선언 시 자바는 final, PL/SQL은 CONSTANT
*/
-------------------------------------------------------------------------------
DECLARE
    NAME VARCHAR2(10);
    AGE NUMBER;
    CLASS CONSTANT CHAR(1) := 'C';
BEGIN
    NAME := '&이름';
    AGE := &나이;
    DBMS_OUTPUT.PUT_LINE('이름: '||NAME||', 나이: '|| AGE||'세, 강의실: '||CLASS);
END;
/
-- 값을 입력 받아서 변수에 대입
-- &변수명 형식으로 작성 시 값을 입력받을 수 있음

DECLARE
    EID NUMBER;
    ENAME VARCHAR2(10);
BEGIN
    --ENAME := '김솔음';
    ENAME := '&이름';     -- 문자를 입력받을 때는 작은 따옴표로 전체를 감싸주면 됨!
    -- &변수명(입력받은 값) 자체를 ''로 감싸 문자로 인식시키는 것
    EID := &사번;
    
    DBMS_OUTPUT.PUT_LINE('이름: '||ENAME);
    DBMS_OUTPUT.PUT_LINE('사번: '||EID);
END;
/
-------------------------------------------------------------------------------
/*
    참조(레퍼런스) 타입 변수
    %TYPE
    : 특정 테이블의 특정 컬럼 데이터 타입을 그대로 가져와서 변수로 선언
    => 컬럼 타입이 추후에 바뀌더라도 코드 수정 필요 없음!
    
    변수명 테이블명.컬럼명%TYPE;
*/
-------------------------------------------------------------------------------
-- EMPLOYEE 테이블의 EMP_ID 컬럼, EMP_NAME 컬럼, SALARY 컬럼을 참조하여
-- 변수명은 EID, ENAME, SAL이라는 변수 선언
DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY
    INTO EID, ENAME, SAL
    FROM EMPLOYEE
    WHERE EMP_ID = '&사번';
    
    DBMS_OUTPUT.PUT_LINE(EID||'번 사원의 이름은 '||ENAME||', 급여는 '||SAL||'원입니다.');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('오류: 존재하지 않는 직원입니다.');
END;
/

-- [QUIZ] 직원 번호를 입력 받아, 해당 직원의 직원번호, 이름, 직급코드, 급여, 부서명 출력
-- 출력 형식 (210번 예): 210, 윤은해, J7, 2000000, 해외영업1부
-- => 예외처리부 실습 전이므로, 사번 BETWEEN 200 AND 222
DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    JCODE EMPLOYEE.JOB_CODE%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
    DTITLE DEPARTMENT.DEPT_TITLE%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY, DEPT_TITLE
    INTO EID, ENAME, JCODE, SAL, DTITLE
    FROM EMPLOYEE
        LEFT JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
        -- 부서 배치 안 받은 직원까지 출력되도록 하기 위한 LEFT JOIN
    WHERE EMP_ID = '&사번';
    
    DBMS_OUTPUT.PUT_LINE(EID||', '||ENAME||', '||JCODE||', '
                        ||NVL(SAL, 0)||'원, '||NVL(DTITLE, '미배정'));
    -- 따로 NVL 처리를 하지 않으면 null 값은 공백으로 출력됨
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('오류: 해당 사번의 직원이 없습니다.');
END;
/
-- SELECT문민 따로 실행해서 문제가 없는지 확인해보면 좋음!
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY, DEPT_TITLE
FROM EMPLOYEE
    LEFT JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
WHERE EMP_ID = '&사번';
-------------------------------------------------------------------------------
/*
    ROW 타입 변수
    [%ROWTYPE]
    : 테이블의 한 행 전체를 통째로 담을 수 있는 변수 (자바의 참조변수와 유사)
    
    변수명 테이블명%ROWTYPE
*/
-------------------------------------------------------------------------------
DECLARE
    E EMPLOYEE%ROWTYPE;
BEGIN
    SELECT *
    INTO E
    FROM EMPLOYEE
    WHERE EMP_ID = '&사번';
    
    DBMS_OUTPUT.PUT_LINE('이름: '||E.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('급여: '||NVL(E.SALARY, 0)||'원');
    DBMS_OUTPUT.PUT_LINE('보너스: '||NVL(E.BONUS, 0) * 100 ||'%');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('오류: 해당 사번의 직원이 없습니다.');
END;
/
-------------------------------------------------------------------------------
/*
    실행부 (BEGIN)
    
    * 제어문 - 조건문 *
        - 단일 IF문: IF 조건식 THEN 실행내용;
                    END IF;
        - IF/ELSE문: IF 조건식 THEN 조건식참_실행내용; ELSE 조건식거짓_실행내용;
                    END IF;
        - IF/ELSIF문: IF 조건식1 THEN 조건식1참_실행내용;
                     ELSIF 조건식2 THEN 조건식2참_실행내용;
                     ...
                     ELSE 조건식다거짓_실행내용;
                     END IF;
        => 자바에서는 else if, 오라클에서는 ELSIF    
*/
-------------------------------------------------------------------------------
DECLARE
    SCORE NUMBER;
    GRADE CHAR(1);
BEGIN
    SCORE := &점수;
    -- 90 이상 A, 80 이상 B, 70 이상 C, 60 이상 D, 나머지 F
    -- 점수는 XX점이고, 등급은 X입니다 (출력)
    IF SCORE >= 90 THEN GRADE := 'A';
    ELSIF SCORE >= 80 THEN GRADE := 'B';
    ELSIF SCORE >= 70 THEN GRADE := 'C';
    ELSIF SCORE >= 60 THEN GRADE := 'D';
    ELSE GRADE := 'F';
    END IF;
    DBMS_OUTPUT.PUT_LINE('점수는 '||SCORE||'점이고, 등급은 '||GRADE||'입니다.');
    
    IF GRADE = 'F' THEN
        DBMS_OUTPUT.PUT_LINE('F 등급은 재평가 대상입니다.');
    END IF;
END;
/
-- 사번, 이름, 급여, 보너스 정보를 출력
-- 보너스 안 받는 경우: '보너스를 받지 않는 직원입니다.' 출력
-- 보너스 받는 경우: 해당 값을 출력
DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
    BONUS EMPLOYEE.BONUS%TYPE;
BEGIN
    -- 사번을 입력 받아, 해당 직원 정보를 조회하여 변수에 저장
    SELECT EMP_ID, EMP_NAME, SALARY, BONUS
    INTO EID, ENAME, SAL, BONUS
    FROM EMPLOYEE
    WHERE EMP_ID = '&사번';
    
    -- 저장된 값을 출력
    DBMS_OUTPUT.PUT_LINE('사번: '||EID);
    DBMS_OUTPUT.PUT_LINE('이름: '||ENAME);
    DBMS_OUTPUT.PUT_LINE('급여: '||SAL||'원');
    IF BONUS IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('보너스를 받지 않는 직원입니다.');
    ELSE  DBMS_OUTPUT.PUT_LINE('보너스: '||BONUS * 100||'%');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('오류: 해당 사번의 직원이 없습니다.');
END;
/
-------------------------------------------------------------------------------
/*
    * 반복문 *
    
    - FOR LOOP문: 자바의 for문과 유사
        FOR 변수명 IN 초기값..끝값
        LOOP
            반복할 내용
        END LOOP;
*/
-------------------------------------------------------------------------------
-- TEST 테이블, SEQ_TNO 시퀀스 생성 (기존에 존재하는 경우 제거 후 생성)
-- TEST 테이블: TNO(PK, 숫자), TDATE(날짜)
-- SEQ_TNO 시퀀스: 1부터 시작, 1000까지만 증가, 2씩 증가, 순환X, 캐시X
-- TEST 테이블
DROP TABLE TEST;
CREATE TABLE TEST(
    TNO NUMBER CONSTRAINT PK_TEST PRIMARY KEY,
    TDATE DATE
);

DROP SEQUENCE SEQ_TNO;

CREATE SEQUENCE SEQ_TNO
    --START WITH 1
    INCREMENT BY 2
    MAXVALUE 1000
    --NOCYCLE
    NOCACHE;

-- TEST 테이블에 100개의 데이터를 추가
BEGIN 
    FOR I IN 1..100
    LOOP
        -- 데이터 추가
        INSERT INTO TEST VALUES(SEQ_TNO.NEXTVAL, SYSDATE);
    END LOOP;
    
    COMMIT;     -- 100개의 데이터 추가 완료 후 적용 (COMMIT)
END;
/
SELECT COUNT(*) FROM TEST;
-------------------------------------------------------------------------------
/*
    예외처리부 (EXCEPTION)
    : 자바의 try ~ catch 블록과 유사한 역할
    
    EXCEPTION 
        WHEN 예외명1 THEN 처리구문1;
        WHEN 예외명2 THEN 처리구문2;
        WHEN OTHERS THEN 처리구문;    
                        -- 여기의 처리구문: 위를 제외한 모든 예외에 대한 처리구문
        
    자주 만나는 예외들
    1) NO_DATA_FOUND: SELECT INTO의 결과가 1행 미만일 경우 발생
    2) TOO_MANY_ROWS: SELECT INTO의 결과가 여러 행일 때 발생
    3) ZERO_DIVIDE: ArithmeticException과 동일(0으로 나누려고 할 때)
    4) DUP_VAL_ON_INDEX: 기본키(PK), UNIQUE 등 중복된 값을 저장하려고 할 때 발생
*/
-------------------------------------------------------------------------------
-- 사번을 입력받아, 노옹철 직원의 번호를 변경
BEGIN
    UPDATE EMPLOYEE
        SET EMP_ID = '&변경할사번'
    WHERE EMP_NAME = '노옹철';
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('ERROR! 중복된 사번입니다.');
END;
/

SELECT EMP_ID, EMP_NAME
FROM EMPLOYEE
WHERE EMP_NAME = '노옹철';

ROLLBACK;
-------------------------------------------------------------------------------
/*
    PL/SQL 프로시저
    : 특정 비즈니스 로직을 처리하는 PL/SQL 코드를 DB에 저장해둘 수 있는 객체
    
    * 매개변수 종류
        - IN: 자바 메서드의 매개변수처럼, 외부에서 프로시저 내부로 값을 가지고 올 때 사용
        - OUT: 자바 메서드의 반환값처럼 프로시저가 처리한 결과를 외부로 줄 때 사용
*/
-------------------------------------------------------------------------------
-- INSERT_TEST_DATA라는 이름의 프로시저 객체 생성
-- => 전달된 개수(DCOUNT)만큼 TEST 테이블에 데이터 추가
CREATE OR REPLACE PROCEDURE INSERT_TEST_DATA
(
    DCOUNT IN NUMBER
)
IS
BEGIN 
    FOR I IN 1..DCOUNT
    LOOP
        -- 데이터 추가
        INSERT INTO TEST VALUES(SEQ_TNO.NEXTVAL, SYSDATE);
    END LOOP;
    
    COMMIT;     -- 100개의 데이터 추가 완료 후 적용(COMMIT)
    
    DBMS_OUTPUT.PUT_LINE(DCOUNT||'개의 데이터가 추가되었습니다.');
END;
/
--> Procedure INSERT_TEST_DATA이(가) 컴파일되었습니다.
-- 계정에 프로시저가 저장되었다는 뜻!

ROLLBACK;
SELECT SEQ_TNO.CURRVAL FROM DUAL;

-- 생성된 프로시저를 사용 (실행)
EXEC INSERT_TEST_DATA(50);
CALL INSERT_TEST_DATA(20);

BEGIN
    INSERT_TEST_DATA(100);
END;
/

SELECT COUNT(*) FROM TEST;

DELETE FROM TEST;






















