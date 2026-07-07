/*
    JOIN: 여러 개의 테이블을 연결(결합)하여 하나의 가상 테이블처럼 조회하는 구문
*/
-- 직원 정보 조회 (직원번호, 이름, 부서코드)
SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE;

-- 부서 정보 조회 (부서번호, 부서명)
SELECT DEPT_ID, DEPT_TITLE
FROM DEPARTMENT;

-- 직원 정보 조회 (직원번호, 이름, 부서명)
/*
    등가 조인 / 내부 조인: 두 테이블의 조인 조건에 해당하는 값들만 결과로 표시
                    => 즉, 조건에 맞지 않는 행은 결과에서 제외됨!
*/
-- 오라클 전용 구문
/*
    FROM절에 조회하고자 하는 테이블 나열(,로 구분)
    WHERE절에 조인 조건을 작성
*/
SELECT EMP_ID, EMP_NAME, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID;
-- EMPLOYEE 테이블에서 부서코드(DEPT_CODE)가 NULL인(부서 미배정) 직원은 결과에서 제외됨.
-- DEPARTMENT 테이블에서 D3, D4, D7 부서코드에 해당하는 직원이 EMPLOYEE 테이블에 존재하지 않아 결과에서 제외됨.

-- 직원 번호, 이름, 직급명 조회
SELECT JOB_CODE, JOB_NAME
FROM JOB;

SELECT EMP_ID, EMP_NAME, JOB_CODE
FROM EMPLOYEE;

SELECT EMP_ID, EMP_NAME, JOB_NAME
FROM EMPLOYEE E, JOB J           -- 테이블에 별칭 부여
WHERE E.JOB_CODE = J.JOB_CODE;
--> 컬럼명이 동일한 경우 테이블을 명시해주어야 함!!!
-- ANSI 표준 구문
/*
    FROM절에 기준이 되는 테이블을 작성
    JOIN 절에 연결하고자 하는 테이블을 작성 + 조인 조건을 작성
    - USING: 컬럼명이 동일한 경우
    - ON: 컬럼명이 동일하거나 다른 경우
*/
-- 사번, 이름, 부서명 조회
SELECT EMP_ID, EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
    JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;

-- 사번, 이름, 직급명 조회
SELECT EMP_ID, EMP_NAME, JOB_NAME
FROM EMPLOYEE
    JOIN JOB USING (JOB_CODE);

SELECT EMP_ID, EMP_NAME, JOB_CODE
FROM EMPLOYEE E
    JOIN JOB J ON E.JOB_CODE = J.JOB_CODE;
----------------------------------------------------------------------------
/*
    포괄 조인 / 외부 조인 (OUTER JOIN)
    : 두 테이블을 조인할 때, 조인 조건에 맞지 않는 행도 결과에 포함하는 구문
    
    LEFT OUTER JOIN: 두 테이블 중 왼쪽에 작성된 테이블을 기준으로 조인
                    (왼쪽 테이블의 모든 행 + 조건에 맞는 오른쪽 테이블 행)
    RIGHT OUTER JOIN: 두 테이블 중 오른쪽에 작성된 테이블을 기준으로 조인
                    (조건에 맞는 왼쪽 테이블 행 + 오른쪽 테이블의 모든 행)
    FULL OUTER JOIN: 두 테이블이 가진 모든 행을 조회하는 구문 (오라클 전용 구문 없음.)
*/
-- LEFT JOIN
/* 오라클 구문
   : 추가로 연결되는 테이블에 해당하는 컬럼 옆에 (+) 기호를 붙여 표현 */
-- 이름, 부서명, 급여 정보 조회(모든 직원 정보를 조회)
SELECT EMP_NAME, DEPT_TITLE, SALARY
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID (+);

-- ANSI 구문
SELECT EMP_NAME, DEPT_TITLE, SALARY
FROM EMPLOYEE
    LEFT JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;

-- RIGHT JOIN
-- 오라클 구문
-- 이름, 부서명, 급여 정보 조회 (모든 부서 정보를 조회)
SELECT EMP_NAME, DEPT_TITLE, SALARY
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE (+) = DEPT_ID;

-- ANSI 구문
SELECT EMP_NAME, DEPT_TITLE, SALARY
FROM EMPLOYEE
    RIGHT JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;

-- FULL OUTER JOIN
-- 오라클 구문 없음!!!!!!

-- ANSI 구문-- 이름, 부서명, 급여 조회 (모든 직원, 모든 부서 조회)
SELECT EMP_NAME, DEPT_TITLE, SALARY
FROM EMPLOYEE
    FULL JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;
------------------------------------------------------------------------------
/*
    비등가 조인 (NON EQUAL JOIN)
    : 조인 조건에 '=' 대신 >, <. BETWEEN, LIKE 등의 비교 연산자를 사용하여 매칭하는 조인
      (주로 범위 조건으로 매칭할 때 사용)
    
    ANSI 구문에서는 JOIN ON만 사용 가능 (USING 사용 불가)
*/
-- 직원에 대한 급여 등급 조회 (이름, 급여, 등급)
-- 오라클 구문
SELECT EMP_NAME, SALARY, SAL_LEVEL
FROM EMPLOYEE, SAL_GRADE
--WHERE SALARY >= MIN_SAL AND SALARY <= MAX_SAL;
WHERE SALARY BETWEEN MIN_SAL AND MAX_SAL;

-- ANSI 구문
SELECT EMP_NAME, SALARY, SAL_LEVEL
FROM EMPLOYEE
    --JOIN SAL_GRADE ON SALARY >= MIN_SAL AND SALARY <= MAX_SAL;
    JOIN SAL_GRADE ON SALARY BETWEEN MIN_SAL AND MAX_SAL;
-------------------------------------------------------------------------------
/*
    자체 조인 / 셀프 조인
    : 하나의 테이블을 마치 서로 다른 테이블처럼 별칭을 주어 조인하는 구문
      테이블 내에 자기 자신과 관계가 있는 데이터를 조회할 때 사용
*/
-- 전체 직원의 사번, 이름, 부서코드, 사수사번, 사수이름, 사수부서코드
-- 오라클 구문
SELECT E.EMP_ID 사번, E.EMP_NAME 이름, E.DEPT_CODE 부서코드,
        M.EMP_ID "사수 사번", M.EMP_NAME "사수 이름", M.DEPT_CODE "사수 부서코드"
FROM EMPLOYEE E, EMPLOYEE M
WHERE E.MANAGER_ID = M.EMP_ID;

-- ANSI 구문
SELECT E.EMP_ID 사번, E.EMP_NAME 이름, E.DEPT_CODE 부서코드,
        M.EMP_ID "사수 사번", M.EMP_NAME "사수 이름", M.DEPT_CODE "사수 부서코드"
FROM EMPLOYEE E
    JOIN EMPLOYEE M ON E.MANAGER_ID = M.EMP_ID;

-- 사수가 없는 직원도 조회
SELECT E.EMP_ID 사번, E.EMP_NAME 이름, E.DEPT_CODE 부서코드,
        M.EMP_ID "사수 사번", M.EMP_NAME "사수 이름", M.DEPT_CODE "사수 부서코드"
FROM EMPLOYEE E
    LEFT JOIN EMPLOYEE M ON E.MANAGER_ID = M.EMP_ID;

SELECT E.EMP_ID 사번, E.EMP_NAME 이름, E.DEPT_CODE 부서코드,
        M.EMP_ID "사수 사번", M.EMP_NAME "사수 이름", M.DEPT_CODE "사수 부서코드"
FROM EMPLOYEE E, EMPLOYEE M
WHERE E.MANAGER_ID = M.EMP_ID (+);
-------------------------------------------------------------------------------
/*
    다중 조인: 2개 이상의 테이블을 조인하는 것
*/
-- 직원번호, 직원명, 부서명, 직급명 조회
-- 오라클 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE E, DEPARTMENT, JOB J
WHERE DEPT_CODE = DEPT_ID   -- EMPLOYEE 테이블과 DEPARTMENT 테이블을 조인하기 위한 조건
    AND E.JOB_CODE = J.JOB_CODE  -- EMPLOYEE 테이블과 JOB 테이블을 조인하기 위한 조건
ORDER BY 1;

-- ANSI 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE E
    JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
    JOIN JOB USING (JOB_CODE)
    --JOIN JOB J ON E.JOB_CODE = J.JOB_CODE
ORDER BY 1;

-- 직원번호, 직원명, 부서명, 지역명 조회
-- 오라클 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE, DEPARTMENT, LOCATION
WHERE DEPT_CODE = DEPT_ID
    AND LOCATION_ID = LOCAL_CODE
ORDER BY 1;

-- ANSI 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, LOCAL_NAME
FROM DEPARTMENT
    JOIN EMPLOYEE ON DEPT_ID = DEPT_CODE
    JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
ORDER BY 1;

-- 선생님 풀이
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE
    JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
    JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
ORDER BY 1;
















