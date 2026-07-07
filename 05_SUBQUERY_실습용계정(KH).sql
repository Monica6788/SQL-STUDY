/*
    서브쿼리: 하나의 쿼리문 내에서 사용되는 또 다른 쿼리문
            메인 쿼리문의 조건이나 결과를 위해 먼저 실행되어 값을 제공 (보조 역할)
*/
-- 노옹철 직원과 같은 부서에 속한 직원 정보를 조회
-- 1) 노옹철 직원의 부서코드 조회
SELECT DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '노옹철';     --> D9

-- 2) 부서코드가 D9인 직원들의 정보 조회
SELECT *
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';

-- 1), 2)를 하나로 합치기
SELECT *
FROM EMPLOYEE
WHERE DEPT_CODE = (
        SELECT DEPT_CODE
        FROM EMPLOYEE
        WHERE EMP_NAME = '노옹철');

-- 전체 직원의 평균 급여보다 더 많은 급여를 받는 직원 정보를 조회
-- 1) 전체 직원의 평균 급여 조회
SELECT FLOOR(AVG(SALARY))
FROM EMPLOYEE;

-- 2) 평균 급여보다 더 많이 받는 직원 조회
SELECT EMP_NAME
FROM EMPLOYEE
WHERE SALARY > 3047662;

-- 1), 2)를 하나로 합치기
SELECT *
FROM EMPLOYEE
WHERE SALARY > (
    SELECT AVG(SALARY)
    FROM EMPLOYEE);
------------------------------------------------------------------------------
/*
    서브쿼리의 종류
    : 서브쿼리를 수행한 결과의 "행"과 "열"의 수에 따라 분류
    
    1. 단일행 서브쿼리: 수행 결과가 오로지 1개 (1행 1열)
    2. 다중행 서브쿼리: 수행 결과가 여러 행 (N행 1열)
    3. 다중열 서브쿼리: 수행 결과가 1행이고 여러 개의 컬럼 (1행 N열)
    4. 다중행 다중열 서브쿼리: 수행 결과가 여러 행 여러 열 (N행 M열)
    
    => 종류에 따라 서브쿼리 앞에 사용되는 연산자가 달라질 수 있음!
*/

/*
    단일행 서브쿼리: 비교연산자 사용 가능! (=, !=, >, <,  >=, <=, ...)
*/
-- 최저 급여를 받는 직원의 이름, 급여, 입사일 조회
-- 1) 최저 급여 조회
SELECT MIN(SALARY)
FROM EMPLOYEE;  --> 1380000

-- 2) 최저 급여를 받는 직원 정보 조회
SELECT EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE
WHERE SALARY = 1380000;

-- 1), 2)를 합치기
SELECT EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE
WHERE SALARY = (
    SELECT MIN(SALARY)
    FROM EMPLOYEE);
-----------------------------------------------------------------------------
-- 노옹철 직원보다 급여를 더 많이 받는 직원 정보 조회 (이름, 부서코드, 급여)
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > (
    SELECT SALARY
    FROM EMPLOYEE
    WHERE EMP_NAME = '노옹철');

-- 부서코드가 아닌 부서명을 조회
SELECT EMP_NAME, DEPT_TITLE, SALARY
FROM EMPLOYEE
    JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
WHERE SALARY > (
    SELECT SALARY
    FROM EMPLOYEE
    WHERE EMP_NAME = '노옹철');

-- 부서별 급여합이 가장 큰 부서의 부서코드, 총급여 조회
-- 1) 부서별 급여 합의 최댓값
-- 1-1) 부서별 급여 합
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;
-- 1-2) 부서별 급여합의 최댓값
SELECT MAX(SUM(SALARY))  --> 17700000
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 2) 급여 합이 최대인 부서의 부서코드, 급여합 조회
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY) = 17700000;

SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY) = (
    SELECT MAX(SUM(SALARY))
    FROM EMPLOYEE
    GROUP BY DEPT_CODE);


-- 전지연 직원과 같은 부서인 직원들의 직원번호, 직원명, 연락처, 입사일, 부서명을 조회
-- 단, 조회 결과에서 전지연 직원 정보는 제외
-- 1) 전지연 직원의 부서코드 조회
SELECT DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '전지연';

-- 2) 1)의 쿼리문을 서브쿼리로 사용하여 같은 부서의 직원 정보 조회
SELECT EMP_ID, EMP_NAME, PHONE, HIRE_DATE, DEPT_TITLE
FROM EMPLOYEE
    JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
WHERE EMP_NAME != '전지연' AND
    DEPT_CODE = (
       SELECT DEPT_CODE
       FROM EMPLOYEE
       WHERE EMP_NAME = '전지연');



















