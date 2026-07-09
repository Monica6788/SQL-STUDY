/*
    SQL
    
    - D: DATA / L: LANGUAGE
    - DQL (QUERY, 데이터 질의 언어): 데이터 조회, SELECT(조회)
    - DDL (DEFINITION, 데이터 정의 언어): 구조(규칙, 틀) 관리.
                        CREATE(생성), ALTER(변경), DROP(삭제)
    - DML (MANIPULATION, 데이터 조작 언어): 데이터 관리(조작)
                        INSERT(추가/삽입), UPDATE(변경), DELETE(삭제)
    - TCL (TRANSACTION CONTROL, 트랜잭션 제어 언어): COMMIT(적용), ROLLBACK(취소)
    - DCL (CONTROL, 데이터 제어 언어): GRANT(권한 부여), REVOKE(권한 회수)
*/
------------------------------------------------------------------------------
/*
    DML (데이터 조작 언어)
    : 테이블에 데이터(값)를 추가(INSERT)하거나,
                         변경(UPDATE)하거나,
                         삭제(DELETE)하기 위해 사용하는 언어

    - INSERT: 테이블에 새로운 행을 추가하는 구문
    [1] INSERT INTO 테이블명 VALUES (값, 값, 값, ...)
        테이블의 모든 컬럼에 대한 값을 직접 제시하여 추가하고자 할 때 사용
        컬럼 순서에 맞게 값을 나열해야 하고, 해당 컬럼에 맞는 데이터 타입으로 제시해야 함.
        
        값을 부족하게 제시할 경우: NOT ENOUGH VALUE... 오류 발생
        값을 더 많이 제시할 경우: TOO MANY VALUES... 오류 발생
    
    [2] INSERT INTO 테이블명 (컬럼명1, 컬럼명2, 컬럼명3, ...)
                    VALUES (값1, 값2, 값3, ...)
        컬럼을 직접 제시하여 해당 컬럼에 값을 추가
        제시하지 않은 컬럼에 대한 값은 기본적으로 NULL값이 저장되고,
         NULL값이 아닌 값을 저장하고자 한다면 기본값 옵션(DEFAULT)을 설정해야 한다.
         
        제시하지 않은 컬럼에 "NOT NULL" 제약조건이 있다면?
        => 반드시 직접 값을 제시하거나 기본값 옵션을 추가해야 함!
    
    [3] INSERT INTO 테이블명 (서브쿼리)
        VALUES로 값을 직접 명시하는 대신, 서브쿼리로 조회된 결과값을 통째로 INSERT하는 방법
        (여러 행을 한 번에 추가하는 방식)
    
    [4] INSERT ALL
        두 개 이상의 테이블에 각각 데이터를 추가할 때 사용
        사용되는 서브쿼리가 동일한 경우에 적용하는 방법
        
        INSERT ALL
            INTO 테이블명1 VALUES (컬럼명, 컬럼명, ...)
            INTO 테이블명2 VALUES (컬럼명, 컬럼명, ...)
            (서브쿼리)
            
        => VALUES 다음에 작성하는 컬럼명은 서브쿼리의 결과(RESULT SET)에 표시되는 컬럼명이어야 함!
*/
-- EMPLOYEE 테이블에 데이터 추가하기 [1]
SELECT * FROM EMPLOYEE;

INSERT INTO EMPLOYEE VALUES (900, '장현우', '880709-1234567', 'hw000@kh.or.kr',
            NULL, 'D4', 'J4', 4000000, 0.3, NULL, SYSDATE, NULL, 'N');
-- COMMIT을 안 했기 때문에 실제 물리적으로 추가되지는 않았음.


-- EMPLOYEE 테이블에 데이터 추가 [2]
-- 직원번호, 이름, 주민번호, 이메일, 직급코드만 가지고 추가
INSERT INTO EMPLOYEE (EMP_ID, EMP_NAME, EMP_NO, EMAIL, JOB_CODE)
            VALUES (901, '공윤정', '040709-4123456', 'yj000@kh.or.kr', 'J6');

-- EMP01 테이블에 데이터 추가 [3]
-- EMP01 테이블 추가: 직원번호(EMP_ID), 이름(EMP_NAME), 부서명(DEPT_TITLE)
CREATE TABLE EMP01 (
    EMP_ID VARCHAR2(3),
    EMP_NAME VARCHAR2(20),
    DEPT_TITLE VARCHAR2(35)
);
-- AUTO COMMIT이 실행되어 위에서 한 것까지 전부 커밋 완료
-- 물리적으로도 이것저것 추가된 상태

SELECT * FROM EMP01;

-- 전체 직원의 직원번호, 이름, 부서명을 조회
-- 오라클 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID(+);

-- ANSI 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
    LEFT JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;

-- EMP01 테이블에 데이터 추가
INSERT INTO EMP01 (
    SELECT EMP_ID, EMP_NAME, DEPT_TITLE
    FROM EMPLOYEE
    LEFT JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID);

-- EMP_DEPT와 EMP_MANAGER에 같은 데이터 추가 [4]    
-- EMP_DEPT 테이블: 직원번호(EMP_ID), 이름(EMP_NAME), 부서코드(DEPT_CODE), 입사일(HIRE_DATE)
CREATE TABLE EMP_DEPT
AS (SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE FROM EMPLOYEE WHERE 0 = 1);

SELECT * FROM EMP_DEPT;

-- EMP_MANAGER 테이블: 직원번호(EMP_ID), 이름(EMP_NAME), 사수번호(MANAGER_ID)
CREATE TABLE EMP_MANAGER
AS (SELECT EMP_ID, EMP_NAME, MANAGER_ID FROM EMPLOYEE WHERE 1024 = 1);

SELECT * FROM EMP_MANAGER;

-- 부서코드가 D1인 직원의 직원번호, 이름, 부서코드, 사수번호, 입사일 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, MANAGER_ID, HIRE_DATE
FROM EMPLOYEE
WHERE DEPT_CODE = 'D1';

INSERT ALL
    INTO EMP_DEPT VALUES(EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE)
    INTO EMP_MANAGER VALUES (EMP_ID, EMP_NAME, MANAGER_ID)
    (SELECT EMP_ID, EMP_NAME, DEPT_CODE, MANAGER_ID, HIRE_DATE
     FROM EMPLOYEE
     WHERE DEPT_CODE = 'D1');
-------------------------------------------------------------------------------
/*
    - UPDATE: 테이블에 저장되어 있는 기존의 데이터를 변경하는 구문
    
    UPDATE 테이블명
        SET 컬럼명 = 변경할값,
            컬럼명 = 변경할값,
                 ...
    [WHERE 조건식];
    
    SET절에서는 여러 개의 컬럼을 동시에 변경 가능 (콤마(,)로 나열해야 함)
    WHERE절을 생략할 경우 테이블의 모든 행이 변경되므로 주의!
*/
-- DEPT_TABLE 테이블에 DEPARTMENT 테이블을 복제 (+ 데이터 포함)
CREATE TABLE DEPT_TABLE
AS (SELECT * FROM DEPARTMENT);

SELECT * FROM DEPARTMENT;
SELECT * FROM DEPT_TABLE;

-- 부서코드가 D1인 부서명을 '인사팀'으로 변경
UPDATE DEPT_TABLE
SET DEPT_TITLE = 'HUMAN RESOURCE MANAGEMENT'
WHERE DEPT_ID = 'D1';

-- 부서명 '총무부' -> '전략기획팀' 변경 (기본키 컬럼을 조건으로 제시)
UPDATE DEPT_TABLE
SET DEPT_TITLE = 'STRATEGIC PLANNING'
WHERE DEPT_ID = 'D9';

-- EMP_TABLE 테이블에 EMPLOYEE 테이블 복제 (직원번호, 이름, 부서코드, 급여, 보너스)
CREATE TABLE EMP_TABLE AS(
    SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY, BONUS FROM EMPLOYEE);

SELECT * FROM EMP_TABLE;

-- 직원번호가 900인 직원의 급여를 500만원으로 변경 (인상)
UPDATE EMP_TABLE
SET SALARY = 5000000,
    EMP_NAME = '허현우'
WHERE EMP_ID = 900;

-- 대북혼 직원의 급여를 450만원으로 변경하고, 보너스를 0.2로 변경
UPDATE EMP_TABLE
SET SALARY = 4500000,
    BONUS = 0.2
WHERE EMP_NAME = '대북혼';

-- 전체 직원의 급여를 10% 인상
UPDATE EMP_TABLE
SET SALARY = SALARY * 1.1;
-------------------------------------------------------------------------------
/*
    UPDATE문에 서브쿼리 사용하기
    
    UPDATE 테이블명
    SET 컬럼명 = (서브쿼리)
    [WHERE 조건];
*/
-- 방명수 직원의 급여와 보너스를 유재식 직원의 급여, 보너스와 동일하게 변경
UPDATE EMP_TABLE
SET SALARY = (SELECT SALARY FROM EMP_TABLE WHERE EMP_NAME = '유재식'),
    BONUS = (SELECT BONUS FROM EMP_TABLE WHERE EMP_NAME = '유재식')
WHERE EMP_NAME = '방명수';

-- 다중열 서브쿼리
-- 튜플 형태로 SET절을 작성
SELECT *
FROM EMP_TABLE
WHERE (SALARY, BONUS) = (SELECT SALARY, BONUS FROM EMP_TABLE WHERE EMP_NAME = '허현우');

UPDATE EMP_TABLE
SET (SALARY, BONUS) = (SELECT SALARY, BONUS FROM EMP_TABLE WHERE EMP_NAME = '허현우')
WHERE EMP_NAME = '공윤정';

SELECT * FROM EMP_TABLE;

-- ASIA 지역에서 근무중인 직원들의 보너스를 0.3으로 변경
-- ASIA 지역정보 조회
SELECT * FROM LOCATION WHERE LOCAL_NAME LIKE 'ASIA%';

-- ASIA 지역에 속한 부서 조회
SELECT *
FROM DEPARTMENT
    JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
WHERE LOCAL_NAME LIKE 'ASIA%';

-- 해당 부서에 속한 직원 조회 (직원번호)
SELECT EMP_ID
FROM EMP_TABLE
    JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
    JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
WHERE LOCAL_NAME LIKE 'ASIA%';  -- 19행
----> 다중행 서브쿼리! => IN 이용

UPDATE EMP_TABLE
SET BONUS = 0.3
WHERE EMP_ID IN (
    SELECT EMP_ID
    FROM EMP_TABLE
        JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
        JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
    WHERE LOCAL_NAME LIKE 'ASIA%');

-- 변경사항 적용
COMMIT;
-------------------------------------------------------------------------------
/*
    DELETE: 테이블에 저장되어 있는 데이터를 삭제할 때 사용하는 구문
    
    DELETE FROM 테이블명
    [WHERE 조건];
    
    => WHERE절 생략 시 테이블의 모든 데이터(행)가 삭제되므로 주의
*/
-- EMPLOYEE 테이블의 데이터 삭제
DELETE FROM EMPLOYEE;

SELECT * FROM EMPLOYEE;
ROLLBACK;

-- 901번 직원 데이터를 삭제
DELETE FROM EMP_TABLE WHERE EMP_ID = '901';
SELECT * FROM EMP_TABLE WHERE EMP_ID = '901';

-- 허현우 직원 데이터를 삭제
DELETE FROM EMP_TABLE WHERE EMP_NAME = '허현우';
SELECT * FROM EMP_TABLE WHERE EMP_NAME = '허현우';

/*
    TRUNCATE: 테이블의 전체 행을 삭제할 때 사용하는 구문(DDL)
              ROLLBACK 불가!
              별도의 조건을 제시할 수 없음!
    
    TRUNCATE TABLE 테이블명;
*/
-- EMP_TABLE 데이터 비우기
TRUNCATE TABLE EMP_TABLE;


















